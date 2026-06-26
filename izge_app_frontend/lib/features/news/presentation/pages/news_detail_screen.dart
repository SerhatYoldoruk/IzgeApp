import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/state/activity_state.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';
import 'package:izge_app_frontend/core/models/announcement_model.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:izge_app_frontend/core/services/tts_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final AnnouncementModel news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isLiked = false;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    isLiked = ActivityState.instance.likedIds.value.contains(widget.news.id);
    isSaved = ActivityState.instance.savedIds.value.contains(widget.news.id);
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    ActivityState.instance.toggleLike(widget.news.id, isLiked);
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
    ActivityState.instance.toggleSave(widget.news.id, isSaved);
  }

  bool _isReading = false;

  @override
  void dispose() {
    if (_isReading) {
      TTSService.instance.stop();
    }
    super.dispose();
  }

  void _toggleReading() async {
    if (_isReading) {
      await TTSService.instance.stop();
      if (mounted) setState(() => _isReading = false);
    } else {
      if (mounted) setState(() => _isReading = true);
      final textToRead = "${widget.news.title}. ${widget.news.content}";
      await TTSService.instance.speak(textToRead);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isReading = TTSService.instance.isSpeaking;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/images/images/logo.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'İzge App',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _toggleReading,
            icon: Icon(_isReading ? Icons.stop : Icons.volume_up, color: AppColors.accent),
            label: Text(
              _isReading ? 'Durdur' : 'Sesli Oku',
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            if (widget.news.imageUrl != null && widget.news.imageUrl!.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(24),
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.news.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.surface.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'DUYURU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        DateFormat('d MMMM yyyy').format(widget.news.createdAt),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.news.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),

                  // Actions Row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ActionButton(
                            icon: isLiked ? Icons.favorite : Icons.favorite_border, 
                            color: isLiked ? AppColors.accent : AppColors.textSecondary,
                            label: isLiked ? 'Beğenildi' : 'Beğen',
                            onTap: _toggleLike,
                          ),
                          _ActionButton(
                            icon: isSaved ? Icons.bookmark : Icons.bookmark_border, 
                            color: isSaved ? AppColors.accent : AppColors.textSecondary,
                            label: isSaved ? 'Kaydedildi' : 'Kaydet',
                            onTap: _toggleSave,
                          ),
                          _ActionButton(
                            icon: Icons.share, 
                            label: 'Paylaş',
                            onTap: () {
                              final shareText = '${widget.news.title}\n\n'
                                  '${widget.news.content.length > 150 ? "${widget.news.content.substring(0, 150)}..." : widget.news.content}\n\n'
                                  'Detaylar için web sitemizi ziyaret edin:\n'
                                  'https://www.izgedernegi.org.tr/?SyfNmb=2&pt=%C4%B0ZGEDER';
                              Share.share(shareText);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Article Body
                  Text(
                    widget.news.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bottom Buttons
                  Container(
                    padding: const EdgeInsets.only(top: 24, bottom: 48),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            final shareText = '${widget.news.title}\n\n'
                                '${widget.news.content.length > 150 ? "${widget.news.content.substring(0, 150)}..." : widget.news.content}\n\n'
                                'Detaylar için web sitemizi ziyaret edin:\n'
                                'https://www.izgedernegi.org.tr/?SyfNmb=2&pt=%C4%B0ZGEDER';
                            Share.share(shareText);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Haberi Paylaş', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceElevated,
                            foregroundColor: AppColors.textPrimary,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
                            );
                          },
                          icon: Icon(Icons.support_agent, color: AppColors.background),
                          label: Text('Canlı Desteğe Bağlan', style: TextStyle(color: AppColors.background, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.textSecondary, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color ?? AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
