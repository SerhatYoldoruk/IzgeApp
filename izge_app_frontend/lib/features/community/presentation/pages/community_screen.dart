import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/community/data/models/community_post_model.dart';
import 'package:izge_app_frontend/features/community/presentation/bloc/community_bloc.dart';
import 'package:izge_app_frontend/features/community/presentation/bloc/community_event.dart';
import 'package:izge_app_frontend/features/community/presentation/bloc/community_state.dart';
import 'new_post_screen.dart';
import 'post_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _selectedCategory = 'Tümü';
  final List<String> _categories = [
    'Tümü', 'Genel', 'Otizm', 'Görme Engeli',
    'İşitme Engeli', 'Fiziksel Engel', 'Hukuk', 'Erişilebilirlik'
  ];

  // Son yüklenen gönderileri burada saklıyoruz.
  // BLoC durumu değişse bile (örn. detay ekranına gidince) liste kaybolmuyor.
  List<CommunityPostModel> _cachedPosts = [];

  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(FetchCommunityPosts());
  }

  List<CommunityPostModel> get _filteredPosts {
    if (_selectedCategory == 'Tümü') return _cachedPosts;
    return _cachedPosts.where((p) => p.category == _selectedCategory).toList();
  }

  void _navigateToDetail(int postId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(postId: postId)),
    ).then((_) {
      // Detaydan dönünce listeyi güncelle (state zaten cachedPosts'ta var, sadece yenile)
      if (mounted) {
        context.read<CommunityBloc>().add(FetchCommunityPosts());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Topluluk & Yardım Ağı'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state is CommunityPostsLoaded) {
            // Yeni gönderiler geldiğinde cache'i güncelle
            setState(() {
              _cachedPosts = state.posts;
            });
          } else if (state is CommunityActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message.tr()),
                backgroundColor: AppColors.accent,
              ),
            );
          } else if (state is CommunityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          // İlk yükleme: cache boş ve yükleniyor
          if (state is CommunityLoading && _cachedPosts.isEmpty) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          // Cache doluysa (detaydan dönsek bile, hata olsa bile) listeyi göster
          return RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () async {
              context.read<CommunityBloc>().add(FetchCommunityPosts());
            },
            child: Column(
              children: [
                // Kategori filtresi
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          backgroundColor: AppColors.surfaceElevated,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Gönderi listesi
                Expanded(
                  child: _filteredPosts.isEmpty
                      ? Center(
                          child: Text(
                            _cachedPosts.isEmpty
                                ? 'Henüz hiç gönderi yok.'.tr()
                                : 'Bu kategoride henüz gönderi yok.'.tr(),
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = _filteredPosts[index];
                            final formattedDate =
                                DateFormat('dd MMM, HH:mm', 'tr_TR').format(post.createdAt);

                            return Card(
                              color: AppColors.surfaceElevated,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _navigateToDetail(post.id),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppColors.border,
                                            backgroundImage: post.userAvatar != null
                                                ? NetworkImage(post.userAvatar!)
                                                : null,
                                            child: post.userAvatar == null
                                                ? Icon(Icons.person,
                                                    color: AppColors.textSecondary, size: 16)
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              post.userName ?? 'İsimsiz Üye'.tr(),
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                                color: AppColors.textSecondary, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        post.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        post.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 12),
                                      Divider(color: AppColors.border),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.chat_bubble_outline,
                                                  size: 16, color: AppColors.textSecondary),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${post.repliesCount} ${'Yanıt'.tr()}',
                                                style: TextStyle(
                                                    color: AppColors.textSecondary, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Yanıtla'.tr(),
                                            style: TextStyle(
                                              color: AppColors.accent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final bloc = context.read<CommunityBloc>();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPostScreen()),
          );
          if (result == true && mounted) {
            bloc.add(FetchCommunityPosts());
          }
        },
        backgroundColor: AppColors.accent,
        icon: Icon(Icons.add, color: AppColors.surfaceElevated),
        label: Text(
          'Soru Sor'.tr(),
          style: TextStyle(
            color: AppColors.surfaceElevated,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
