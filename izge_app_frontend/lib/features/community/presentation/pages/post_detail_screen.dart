import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/community/presentation/bloc/community_bloc.dart';
import 'package:izge_app_frontend/features/community/presentation/bloc/community_event.dart';
import 'package:izge_app_frontend/features/community/presentation/bloc/community_state.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _replyController = TextEditingController();
  String? _replyingToName; // @mention hedefi

  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(FetchPostDetail(widget.postId));
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply() {
    final content = _replyController.text.trim();
    if (content.isNotEmpty) {
      context.read<CommunityBloc>().add(
        AddCommunityReply(postId: widget.postId, content: content),
      );
      _replyController.clear();
      setState(() => _replyingToName = null);
      FocusScope.of(context).unfocus();
    }
  }

  void _replyTo(String userName) {
    setState(() => _replyingToName = userName);
    _replyController.text = '@$userName ';
    _replyController.selection = TextSelection.fromPosition(
      TextPosition(offset: _replyController.text.length),
    );
  }

  void _showReportDialog(BuildContext dialogContext, {int? postId, int? replyId}) {
    final reasonController = TextEditingController();
    showDialog(
      context: dialogContext,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Şikayet Et'.tr(), style: TextStyle(color: AppColors.textPrimary)),
          content: TextField(
            controller: reasonController,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Şikayet sebebinizi yazın...'.tr(),
              hintStyle: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('İptal'.tr(), style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  context.read<CommunityBloc>().add(
                    ReportContent(postId: postId, replyId: replyId, reason: reason),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: Text('Gönder'.tr(), style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
          'Yanıtlar'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state is CommunityActionSuccess) {
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
          if (state is CommunityLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (state is CommunityPostDetailLoaded) {
            final post = state.post;
            final replies = state.replies;
            final postDate = DateFormat('dd MMM yyyy, HH:mm', 'tr_TR').format(post.createdAt);
            final currentUserId = Supabase.instance.client.auth.currentUser?.id;

            return Column(
              children: [
                // --- Gönderi + Yanıtlar Listesi ---
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Ana Gönderi Kartı
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.border,
                                  backgroundImage: post.userAvatar != null
                                      ? NetworkImage(post.userAvatar!)
                                      : null,
                                  child: post.userAvatar == null
                                      ? Icon(Icons.person, color: AppColors.textSecondary)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.userName ?? 'İsimsiz Üye'.tr(),
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        postDate,
                                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    post.category,
                                    style: TextStyle(color: AppColors.accent, fontSize: 12),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                                  color: AppColors.surfaceElevated,
                                  onSelected: (val) {
                                    if (val == 'report') _showReportDialog(context, postId: post.id);
                                  },
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(
                                      value: 'report',
                                      child: Text('Şikayet Et'.tr(), style: const TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (post.imageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    post.imageUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Text(
                              post.content,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<CommunityBloc>().add(TogglePostLike(post.id));
                                  },
                                  icon: Icon(Icons.favorite_border, color: AppColors.accent),
                                ),
                                Text(
                                  '${post.likesCount} ${'Beğeni'.tr()}',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Text(
                        '${replies.length} ${'Yanıt'.tr()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Yanıtlar
                      ...replies.map((reply) {
                        final replyDate = DateFormat('dd MMM, HH:mm', 'tr_TR').format(reply.createdAt);
                        final isPostOwner = currentUserId == post.userId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.border,
                                backgroundImage: reply.userAvatar != null
                                    ? NetworkImage(reply.userAvatar!)
                                    : null,
                                child: reply.userAvatar == null
                                    ? Icon(Icons.person, color: AppColors.textSecondary, size: 16)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: reply.isAccepted
                                        ? Colors.green.withValues(alpha: 0.06)
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: reply.isAccepted ? Colors.green.withValues(alpha: 0.4) : AppColors.border,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Başlık satırı: İsim + Çözüm rozeti + Menü
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        reply.userName ?? 'İsimsiz Üye'.tr(),
                                                        style: TextStyle(
                                                          color: AppColors.textPrimary,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    if (reply.isAccepted)
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 6),
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.green.withValues(alpha: 0.2),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Icon(Icons.check_circle, color: Colors.green, size: 12),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              'Çözüm'.tr(),
                                                              style: const TextStyle(
                                                                color: Colors.green,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Text(
                                                  replyDate,
                                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: Icon(Icons.more_vert, color: AppColors.textSecondary, size: 18),
                                            color: AppColors.surfaceElevated,
                                            padding: EdgeInsets.zero,
                                            onSelected: (val) {
                                              if (val == 'report') _showReportDialog(context, replyId: reply.id);
                                            },
                                            itemBuilder: (ctx) => [
                                              PopupMenuItem(
                                                value: 'report',
                                                child: Text('Şikayet Et'.tr(), style: const TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Yanıt içeriği
                                      Text(
                                        reply.content,
                                        style: TextStyle(color: AppColors.textPrimary, height: 1.4),
                                      ),
                                      const SizedBox(height: 10),
                                      // Alt butonlar: Yanıtla + Çözüm İşaretle
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Yanıtla butonu
                                          GestureDetector(
                                            onTap: () => _replyTo(reply.userName ?? 'Üye'),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.reply, size: 14, color: AppColors.accent),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Yanıtla'.tr(),
                                                  style: TextStyle(
                                                    color: AppColors.accent,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Çözüm işaretle (sadece gönderi sahibine görünür)
                                          if (isPostOwner && !reply.isAccepted)
                                            TextButton.icon(
                                              onPressed: () {
                                                context.read<CommunityBloc>().add(
                                                  AcceptReply(replyId: reply.id, postId: post.id),
                                                );
                                              },
                                              icon: const Icon(Icons.check, size: 16, color: Colors.green),
                                              label: Text(
                                                'Çözüm İşaretle'.tr(),
                                                style: const TextStyle(color: Colors.green, fontSize: 12),
                                              ),
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // --- Yazı Kutusu ---
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // @mention göstergesi
                      if (_replyingToName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(Icons.reply, size: 14, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text(
                                '@$_replyingToName kişisine yanıt veriliyor',
                                style: TextStyle(color: AppColors.accent, fontSize: 12),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _replyingToName = null);
                                  _replyController.clear();
                                },
                                child: Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _replyController,
                              style: TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: _replyingToName != null
                                    ? '@$_replyingToName yanıtla...'
                                    : 'Bir yanıt yazın...'.tr(),
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                filled: true,
                                fillColor: AppColors.fieldBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: AppColors.accent,
                            radius: 24,
                            child: IconButton(
                              icon: Icon(Icons.send, color: AppColors.surfaceElevated),
                              onPressed: _submitReply,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Text('Bir hata oluştu.', style: TextStyle(color: AppColors.textPrimary)),
          );
        },
      ),
    );
  }
}
