import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:izge_app_frontend/features/community/data/models/community_post_model.dart';
import 'package:izge_app_frontend/features/community/data/models/community_reply_model.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final SupabaseClient _supabaseClient;

  CommunityBloc(this._supabaseClient) : super(CommunityInitial()) {
    on<FetchCommunityPosts>(_onFetchCommunityPosts);
    on<FetchPostDetail>(_onFetchPostDetail);
    on<AddCommunityPost>(_onAddCommunityPost);
    on<AddCommunityReply>(_onAddCommunityReply);
    on<TogglePostLike>(_onTogglePostLike);
    on<AcceptReply>(_onAcceptReply);
    on<ReportContent>(_onReportContent);
  }

  Future<void> _onFetchCommunityPosts(FetchCommunityPosts event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      final response = await _supabaseClient
          .from('community_posts')
          .select('*')
          .order('created_at', ascending: false);

      final List<dynamic> responseList = response as List<dynamic>;
      
      if (responseList.isNotEmpty) {
        final userIds = responseList.map((p) => p['user_id']).toSet().toList();
        final profilesResponse = await _supabaseClient
            .from('profiles')
            .select('id, full_name, avatar_url')
            .filter('id', 'in', userIds);
            
        final Map<String, dynamic> profilesMap = {
          for (var item in (profilesResponse as List<dynamic>))
            item['id']: item
        };
        
        for (var post in responseList) {
          post['profiles'] = profilesMap[post['user_id']];
        }
      }

      final List<CommunityPostModel> posts = responseList
          .map((json) => CommunityPostModel.fromJson(json))
          .toList();

      emit(CommunityPostsLoaded(posts));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onFetchPostDetail(FetchPostDetail event, Emitter<CommunityState> emit) async {
    if (state is! CommunityPostDetailLoaded) {
      emit(CommunityLoading());
    }
    try {
      // Fetch post
      final postResponse = await _supabaseClient
          .from('community_posts')
          .select('*')
          .eq('id', event.postId)
          .single();
          
      // Fetch post author profile
      final postProfileResponse = await _supabaseClient
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', postResponse['user_id'])
          .maybeSingle();
          
      if (postProfileResponse != null) {
        postResponse['profiles'] = postProfileResponse;
      }
          
      final post = CommunityPostModel.fromJson(postResponse);

      // Fetch replies
      final repliesResponse = await _supabaseClient
          .from('community_replies')
          .select('*')
          .eq('post_id', event.postId)
          .order('created_at', ascending: true);

      final List<dynamic> repliesList = repliesResponse as List<dynamic>;
      
      if (repliesList.isNotEmpty) {
        final replyUserIds = repliesList.map((r) => r['user_id']).toSet().toList();
        final replyProfilesResponse = await _supabaseClient
            .from('profiles')
            .select('id, full_name, avatar_url')
            .filter('id', 'in', replyUserIds);
            
        final Map<String, dynamic> replyProfilesMap = {
          for (var item in (replyProfilesResponse as List<dynamic>))
            item['id']: item
        };
        
        for (var reply in repliesList) {
          reply['profiles'] = replyProfilesMap[reply['user_id']];
        }
      }

      final List<CommunityReplyModel> replies = repliesList
          .map((json) => CommunityReplyModel.fromJson(json))
          .toList();

      // Check if current user liked the post
      bool isLikedByMe = false;
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      if (currentUserId != null) {
        try {
          final likeData = await _supabaseClient
              .from('community_post_likes')
              .select('post_id')
              .eq('post_id', event.postId)
              .eq('user_id', currentUserId)
              .maybeSingle();
          isLikedByMe = likeData != null;
        } catch (_) {
          // Fallback in case table name is different
        }
      }

      emit(CommunityPostDetailLoaded(post, replies, isLikedByMe: isLikedByMe));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onAddCommunityPost(AddCommunityPost event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(const CommunityError("Giriş yapmanız gerekiyor."));
        return;
      }

      String? imageUrl;
      if (event.imagePath != null) {
        final file = File(event.imagePath!);
        final fileExt = file.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        
        await _supabaseClient.storage
            .from('community_images')
            .upload(fileName, file);
            
        imageUrl = _supabaseClient.storage
            .from('community_images')
            .getPublicUrl(fileName);
      }

      await _supabaseClient.from('community_posts').insert({
        'user_id': userId,
        'title': event.title,
        'content': event.content,
        'category': event.category,
        'image_url': imageUrl,
      });

      emit(const CommunityActionSuccess("Soru başarıyla paylaşıldı."));
      add(FetchCommunityPosts());
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onAddCommunityReply(AddCommunityReply event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(const CommunityError("Giriş yapmanız gerekiyor."));
        return;
      }

      await _supabaseClient.from('community_replies').insert({
        'post_id': event.postId,
        'user_id': userId,
        'content': event.content,
      });
      
      // Increment replies_count
      await _supabaseClient.rpc('increment_replies_count', params: {'post_id_param': event.postId});

      emit(const CommunityActionSuccess("Yanıtınız eklendi."));
      add(FetchPostDetail(event.postId));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onTogglePostLike(TogglePostLike event, Emitter<CommunityState> emit) async {
    // 1. Optimistic Update (Anında UI tepkisi)
    if (state is CommunityPostDetailLoaded) {
      final currentState = state as CommunityPostDetailLoaded;
      
      final newIsLikedByMe = !currentState.isLikedByMe;
      final currentLikesCount = currentState.post.likesCount;
      final newLikesCount = newIsLikedByMe 
          ? currentLikesCount + 1 
          : (currentLikesCount > 0 ? currentLikesCount - 1 : 0);
          
      final updatedPost = CommunityPostModel(
        id: currentState.post.id,
        userId: currentState.post.userId,
        title: currentState.post.title,
        content: currentState.post.content,
        likesCount: newLikesCount,
        repliesCount: currentState.post.repliesCount,
        createdAt: currentState.post.createdAt,
        userName: currentState.post.userName,
        userAvatar: currentState.post.userAvatar,
        category: currentState.post.category,
        imageUrl: currentState.post.imageUrl,
      );
      
      emit(CommunityPostDetailLoaded(updatedPost, currentState.replies, isLikedByMe: newIsLikedByMe));
    }

    // 2. Arka Planda API İsteği
    try {
      await _supabaseClient.rpc('toggle_post_like', params: {'p_post_id': event.postId});
      // Veritabanına istek başarıyla gitti. Artık yeniden tüm sayfayı çekmemize gerek yok çünkü UI'ı anında güncelledik.
    } catch (e) {
      // Hata olursa gerçek durumu tekrar çekerek UI'ı düzelt
      add(FetchPostDetail(event.postId));
      emit(CommunityError("Beğeni işlemi başarısız: ${e.toString()}"));
    }
  }

  Future<void> _onAcceptReply(AcceptReply event, Emitter<CommunityState> emit) async {
    try {
      await _supabaseClient.rpc('accept_reply', params: {'p_reply_id': event.replyId});
      emit(const CommunityActionSuccess("Yanıt çözüm olarak işaretlendi."));
      add(FetchPostDetail(event.postId));
    } catch (e) {
      emit(CommunityError("İşlem başarısız: ${e.toString()}"));
    }
  }

  Future<void> _onReportContent(ReportContent event, Emitter<CommunityState> emit) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(const CommunityError("Giriş yapmanız gerekiyor."));
        return;
      }

      await _supabaseClient.from('community_reports').insert({
        'user_id': userId,
        'post_id': event.postId,
        'reply_id': event.replyId,
        'reason': event.reason,
      });
      emit(const CommunityActionSuccess("Şikayetiniz iletildi. Teşekkür ederiz."));
    } catch (e) {
      emit(CommunityError("Şikayet iletilemedi: ${e.toString()}"));
    }
  }
}
