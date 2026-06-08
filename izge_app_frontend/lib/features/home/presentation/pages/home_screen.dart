import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/widgets/social_links_row.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/event_detail_screen.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/events_screen.dart';
import 'package:izge_app_frontend/features/navigation/presentation/widgets/custom_drawer.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_detail_screen.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_screen.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/new_request_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donate_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';

import 'package:izge_app_frontend/features/info_cards/presentation/pages/info_cards_screen.dart';
import 'package:izge_app_frontend/features/info_cards/presentation/pages/info_card_detail_screen.dart';
import 'package:izge_app_frontend/core/constants/dummy_info_cards.dart';
import 'package:izge_app_frontend/features/community/presentation/pages/community_screen.dart';
import 'package:izge_app_frontend/core/widgets/notification_badge_icon.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_bloc.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_state.dart';
import 'package:izge_app_frontend/features/events/presentation/bloc/event_event.dart';
import 'package:izge_app_frontend/features/news/presentation/bloc/news_bloc.dart';
import 'package:izge_app_frontend/features/news/presentation/bloc/news_state.dart';
import 'package:izge_app_frontend/features/news/presentation/bloc/news_event.dart';
import 'package:izge_app_frontend/features/surveys/presentation/bloc/survey_bloc.dart';
import 'package:izge_app_frontend/features/surveys/presentation/bloc/survey_state.dart';
import 'package:izge_app_frontend/features/surveys/presentation/bloc/survey_event.dart';
import 'package:izge_app_frontend/features/surveys/presentation/pages/survey_detail_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _refreshUserData();
    LanguageController.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguageController.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _refreshAllData() {
    context.read<NewsBloc>().add(NewsFetchRequested());
    context.read<EventBloc>().add(EventFetchRequested());
    context.read<SurveyBloc>().add(SurveyFetchRequested());
  }

  void _refreshUserData() {
    if (mounted) {
      setState(() {
        _userDataFuture = _fetchUserData();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {};

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      try {
        final requests = await Supabase.instance.client
            .from('requests')
            .select('id')
            .eq('user_id', user.id)
            .eq('status', 'pending');
        response['pending_count'] = (requests as List).length;
      } catch (e) {
        response['pending_count'] = 0;
      }

      return response;
    } catch (e) {
      debugPrint("Home Veri Çekme Hatası: ${e.toString()}");
      return {
        'full_name': user.userMetadata?['name'] ?? 'Kullanıcı',
        'avatar_url': user.userMetadata?['avatar_url'] ?? '',
        'pending_count': 0,
      };
    }
  }

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
          },
        ),
        title: Row(
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
            const SizedBox(width: 12),
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
          const NotificationBadgeIcon(),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data ?? {};
          final fullName =
              userData['full_name'] ?? userData['name'] ?? 'Kullanıcı';
          final avatarUrl = userData['avatar_url'] ?? '';

          // KESİN ÇÖZÜM: İsim soyisimi boşluklardan ayırıp sadece ilk kelimeyi (yani ilk ismi) alıyoruz
          final firstName = fullName.trim().split(' ').first;

          return RefreshIndicator(
            color: AppColors.accent,
            backgroundColor: AppColors.surfaceElevated,
            onRefresh: () async {
              _refreshUserData();
              _refreshAllData();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // KESİN ÇÖZÜM: Artık burada sadece 'firstName' basılıyor
                          Text(
                            LanguageController.instance.isTurkish
                                ? 'Merhaba $firstName 👋'
                                : 'Hello $firstName 👋',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Builder(
                            builder: (context) {
                              final pendingCount = userData['pending_count'] ?? 0;
                              if (pendingCount > 0) {
                                return Text(
                                  LanguageController.instance.isTurkish
                                      ? 'Bekleyen $pendingCount talebiniz var.'
                                      : 'You have $pendingCount pending requests.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.accent,
                                  ),
                                );
                              } else {
                                return Text(
                                  LanguageController.instance.isTurkish
                                      ? 'Bekleyen talebiniz yok.'
                                      : 'No pending requests.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withOpacity(0.2),
                        ),
                        child: ClipOval(
                          child: avatarUrl.isNotEmpty
                              ? Image.network(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.person,
                                        size: 24,
                                        color: AppColors.textSecondary,
                                      ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 24,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Hızlı İşlemler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuickActionBtn(
                        icon: Icons.volunteer_activism,
                        label: 'Bağış Yap'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonateScreen(),
                            ),
                          );
                        },
                      ),
                      _QuickActionBtn(
                        icon: Icons.event,
                        label: 'Etkinlikler'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EventsScreen(),
                            ),
                          );
                        },
                      ),
                      _QuickActionBtn(
                        icon: Icons.lightbulb_outline,
                        label: 'Bilgiler',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InfoCardsScreen(),
                            ),
                          );
                        },
                      ),
                      _QuickActionBtn(
                        icon: Icons.forum,
                        label: 'Topluluk'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CommunityScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Günlük Bilgi Kartı Banneri
                  _DailyInfoCardBanner(),
                  const SizedBox(height: 32),

                  // Öne Çıkanlar Section
                  _SectionHeader(
                    title: 'Öne Çıkanlar'.tr(),
                    actionLabel: 'Hepsini Gör'.tr(),
                    onActionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: BlocBuilder<NewsBloc, NewsState>(
                      builder: (context, state) {
                        if (state is NewsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is NewsLoaded) {
                          final pinnedNews = state.news.where((a) => a.isPinned).toList();
                          final displayNews = pinnedNews.isNotEmpty ? pinnedNews : state.news;
                          
                          if (displayNews.isEmpty) {
                            return Center(child: Text('Öne çıkan içerik yok', style: TextStyle(color: AppColors.textSecondary)));
                          }

                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: displayNews.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final news = displayNews[index];
                              return _FeaturedCard(
                                tag: 'DUYURU'.tr(),
                                title: news.title.tr(),
                                imageUrl: news.imageUrl, // We assume it's a URL or null
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(news: news),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Canlı Destek Section
                  _LiveSupportCard(
                    onActionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LiveSupportScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Talepler Section
                  _SectionHeader(
                    title: 'Talepler'.tr(),
                    actionLabel: LanguageController.instance.isTurkish
                        ? '+ Yeni Talep'
                        : '+ New Request',
                    onActionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewRequestScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Henüz talep bulunmuyor'.tr(),
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Yaklaşan Etkinlikler Section
                  _SectionHeader(
                    title: 'Yaklaşan Etkinlikler'.tr(),
                    actionLabel: 'Tümünü Gör'.tr(),
                    onActionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<EventBloc, EventState>(
                    builder: (context, state) {
                      if (state is EventLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is EventLoaded) {
                        final upcomingEvents = state.events.where((e) => e.eventDate.isAfter(DateTime.now())).toList();
                        
                        if (upcomingEvents.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Yaklaşan etkinlik bulunmuyor'.tr(),
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          );
                        }

                        // Just display the first upcoming event as a card for now
                        final firstEvent = upcomingEvents.first;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailScreen(event: firstEvent),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.event, color: AppColors.accent),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(firstEvent.title, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text(firstEvent.location ?? 'Bilinmeyen Konum', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 32),

                  // Anketler Section
                  Text(
                    'Anketler'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SurveyBloc, SurveyState>(
                    builder: (context, state) {
                      if (state is SurveyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SurveyLoaded) {
                        final activeSurveys = state.surveys.where((s) => s.status == 'active').toList();
                        
                        if (activeSurveys.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Aktif anket bulunmuyor'.tr(),
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          );
                        }

                        final survey = activeSurveys.first;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurveyDetailScreen(survey: survey),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.poll, color: AppColors.accent),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(survey.title, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text(survey.description ?? '', style: TextStyle(color: AppColors.textSecondary, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 48),

                  // Social Links Section
                  Center(
                    child: Text(
                      'Bizi Takip Edin'.tr(),
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
          );
        },
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
                image: (imageUrl != null && imageUrl!.startsWith('http'))
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : (imageUrl != null
                        ? DecorationImage(
                            image: AssetImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null),
              ),
              child: imageUrl == null
                  ? Center(
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    )
                  : null,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                      'Canlı Destek'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Size yardımcı olmak için buradayız. Hemen sohbete başlayın.'
                          .tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: onActionTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: const StadiumBorder(),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.chat),
                      label: Text(
                        'Bize Yazın'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 80),
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

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
                colors: [
                  AppColors.accent.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Icon(icon, color: AppColors.accent, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyInfoCardBanner extends StatefulWidget {
  const _DailyInfoCardBanner();

  @override
  State<_DailyInfoCardBanner> createState() => _DailyInfoCardBannerState();
}

class _DailyInfoCardBannerState extends State<_DailyInfoCardBanner> {
  InfoCard? _card;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDailyCard();
  }

  Future<void> _loadDailyCard() async {
    try {
      final response = await Supabase.instance.client
          .from('info_cards')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      final dbCards = (response as List).map((e) => InfoCard.fromMap(e)).toList();
      final cards = [...dbCards, ...DummyInfoCards.cards];
      if (cards.isNotEmpty) {
        final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
        final index = dayOfYear % cards.length;
        setState(() {
          _card = cards[index];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2)),
      );
    }
    if (_card == null) return const SizedBox.shrink();

    final card = _card!;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InfoCardDetailScreen(card: card)),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [card.color, card.color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: card.color.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(card.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Günün Bilgisi',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.summary,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8), size: 16),
          ],
        ),
      ),
    );
  }
}
