import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/navigation/presentation/widgets/custom_drawer.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/new_request_screen.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/events_screen.dart';
import 'package:izge_app_frontend/features/surveys/presentation/pages/surveys_screen.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_screen.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_detail_screen.dart';
import 'package:izge_app_frontend/features/support/presentation/pages/live_support_screen.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/event_detail_screen.dart';
import 'package:izge_app_frontend/core/widgets/social_links_row.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notifications_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donate_screen.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/request_detail_screen.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
            icon: Icon(Icons.notifications_none, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Karşılama
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Merhaba Ahmet 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text('Bekleyen 1 talebiniz var.', style: TextStyle(fontSize: 14, color: AppColors.accent)),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.accent.withOpacity(0.2),
                  backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Hızlı İşlemler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickActionBtn(icon: Icons.volunteer_activism, label: 'Bağış Yap', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DonateScreen()));
                }),
                _QuickActionBtn(icon: Icons.add_circle_outline, label: 'Talep Aç', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRequestScreen()));
                }),
                _QuickActionBtn(icon: Icons.event, label: 'Etkinlikler', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EventsScreen()));
                }),
                _QuickActionBtn(icon: Icons.support_agent, label: 'Destek', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveSupportScreen()));
                }),
              ],
            ),
            const SizedBox(height: 32),

            // Öne Çıkanlar Section
            _SectionHeader(title: 'Öne Çıkanlar', actionLabel: 'Hepsini Gör', onActionTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsScreen()));
            }),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FeaturedCard(
                    tag: 'ETKİNLİK',
                    title: 'Engelsiz Yaşam Buluşması',
                    imageUrl: 'assets/images/images/featured_card.png',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EventDetailScreen()));
                    },
                  ),
                  const SizedBox(width: 16),
                  _FeaturedCard(
                    tag: 'DUYURU',
                    title: 'Yeni Rehabilitasyon Merkezi',
                    imageUrl: 'assets/images/images/news_main.png',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsDetailScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Canlı Destek Section
            _LiveSupportCard(onActionTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveSupportScreen()));
            }),
            const SizedBox(height: 32),

            // Talepler Section
            _SectionHeader(title: 'Talepler', actionLabel: '+ Yeni Talep', onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewRequestScreen()),
              );
            }),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Henüz talep bulunmuyor', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(height: 32),

            // Yaklaşan Etkinlikler Section
            _SectionHeader(title: 'Yaklaşan Etkinlikler', actionLabel: 'Tümünü Gör', onActionTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EventsScreen()));
            }),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Yaklaşan etkinlik bulunmuyor', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            SizedBox(height: 32),

            // Anketler Section
            Text(
              'Anketler',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Aktif anket bulunmuyor', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            SizedBox(height: 48),
            
            // Social Links Section
            Center(
              child: Text(
                'Bizi Takip Edin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SocialLinksRow(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String tag;
  final String title;
  final VoidCallback onTap;
  final String? imageUrl;

  const _FeaturedCard({
    required this.tag,
    required this.title,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.background,
                image: imageUrl != null 
                    ? DecorationImage(
                        image: AssetImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null ? Center(
                child: Icon(Icons.image, size: 64, color: Colors.white.withOpacity(0.05)),
              ) : null,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
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

class _LiveSupportCard extends StatelessWidget {
  final VoidCallback onActionTap;

  const _LiveSupportCard({required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent.withOpacity(0.15), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Canlı Destek',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Size yardımcı olmak için buradayız. Hemen sohbete başlayın.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: onActionTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: const StadiumBorder(),
                        elevation: 4,
                      ),
                      icon: Icon(Icons.chat),
                      label: const Text(
                        'Bize Yazın',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 80), // Space for background icon
            ],
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.forum,
              size: 120,
              color: AppColors.textPrimary.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestListCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _RequestListCard({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestDetailScreen()));
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.accent),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _EventListCard extends StatelessWidget {
  final String month;
  final String day;
  final String title;
  final String details;
  final VoidCallback onTap;

  const _EventListCard({
    required this.month,
    required this.day,
    required this.title,
    required this.details,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SurveyCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.poll, color: AppColors.accent),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ankete Katıl',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: AppColors.accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Icon(icon, color: AppColors.accent, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
