import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/profile_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/saved_content_screen.dart';
import 'package:izge_app_frontend/core/state/activity_state.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donation_history_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donate_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/about_us_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';
import 'package:izge_app_frontend/core/theme/theme_controller.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/widgets/social_links_row.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<Map<String, dynamic>>? _drawerUserDataFuture;

  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onThemeChanged);
    LanguageController.instance.addListener(_onLanguageChanged);
    _refreshDrawerUserData();
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    LanguageController.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _refreshDrawerUserData() {
    if (mounted) {
      setState(() {
        _drawerUserDataFuture = _fetchDrawerUserData();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchDrawerUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {};

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
          
      return response;
    } catch (e) {
      debugPrint("Drawer Veri Çekme Hatası: ${e.toString()}");
      return {
        'full_name': user.userMetadata?['name'] ?? 'Kullanıcı',
        'avatar_url': user.userMetadata?['avatar_url'] ?? '',
        'role': 'member',
      };
    }
  }

  // Veritabanından gelen rol değerini ekranda göstereceğimiz Türkçe karşılığına eşleyen fonksiyon
  String _getRoleDisplayName(String? role) {
    if (role == null) return 'Gönüllü Üye'.tr();
    
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Yönetici'.tr();
      case 'moderator':
        return 'Moderatör'.tr();
      case 'corporate':
      case 'enterprise':
        return 'Kurumsal Erişim'.tr();
      case 'member':
      default:
        return 'Gönüllü Üye'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _drawerUserDataFuture,
          builder: (context, snapshot) {
            final userData = snapshot.data ?? {};
            final fullName = userData['full_name'] ?? userData['name'] ?? 'Kullanıcı';
            final avatarUrl = userData['avatar_url'] ?? '';
            final dbRole = userData['role'] as String?;

            final firstName = fullName.trim().split(' ').first;
            // API'den gelen role göre dinamik unvan belirleniyor
            final displayRole = _getRoleDisplayName(dbRole);

            return Column(
              children: [
                // Drawer Header / Profile
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'İzge App',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: AppColors.accent),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context); // Close drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: ClipOval(
                                  child: avatarUrl.isNotEmpty
                                      ? Image.network(
                                          avatarUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.person,
                                            color: AppColors.textSecondary,
                                            size: 32,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: AppColors.textSecondary,
                                          size: 32,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firstName, 
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.verified, color: AppColors.accent, size: 14),
                                      const SizedBox(width: 4),
                                      // DÜZELTİLDİ: Tamamen dinamik API (Supabase) rolü basılıyor
                                      Text(
                                        displayRole,
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(Icons.chevron_right, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Language & Theme Switcher
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Language
                      AnimatedBuilder(
                        animation: LanguageController.instance,
                        builder: (context, _) {
                          final isTr = LanguageController.instance.isTurkish;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DİL'.tr(),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => LanguageController.instance.changeLanguage('tr'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isTr ? AppColors.surfaceElevated : Colors.transparent,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'TR',
                                          style: TextStyle(
                                            color: isTr ? AppColors.accent : AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => LanguageController.instance.changeLanguage('en'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: !isTr ? AppColors.surfaceElevated : Colors.transparent,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'EN',
                                          style: TextStyle(
                                            color: !isTr ? AppColors.accent : AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Theme Toggle
                      GestureDetector(
                        onTap: () {
                          ThemeController.instance.toggleTheme();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TEMA',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 32,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    alignment: ThemeController.instance.isDarkMode
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceElevated,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Icon(
                                            Icons.dark_mode,
                                            color: ThemeController.instance.isDarkMode
                                                ? AppColors.accent
                                                : AppColors.textSecondary,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Icon(
                                            Icons.light_mode,
                                            color: !ThemeController.instance.isDarkMode
                                                ? AppColors.accent
                                                : AppColors.textSecondary,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
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
                
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Navigation Items
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              _DrawerItem(
                                icon: Icons.person, 
                                title: 'Profilim'.tr(), 
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                  );
                                }
                              ),
                              _DrawerItem(
                                icon: Icons.volunteer_activism, 
                                title: 'Bağış Yap'.tr(), 
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DonateScreen()));
                                },
                              ),
                              _DrawerItem(
                                icon: Icons.history, 
                                title: 'Bağış Geçmişi'.tr(), 
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DonationHistoryScreen()));
                                },
                              ),
                              _DrawerItem(
                                icon: Icons.settings, 
                                title: 'Ayarlar'.tr(), 
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                                },
                              ),
                              _DrawerItem(
                                icon: Icons.info, 
                                title: 'Dernek Hakkında'.tr(), 
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
                                },
                              ),
                              _DrawerItem(
                                icon: Icons.help_center, 
                                title: 'Yardım Merkezi'.tr(), 
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Social Media
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: const SocialLinksRow(),
                        ),
                        
                        // Activity Stats
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AKTİVİTEM'.tr(),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ValueListenableBuilder<int>(
                                      valueListenable: ActivityState.instance.likedCount,
                                      builder: (context, count, _) {
                                        return _StatCard(icon: Icons.favorite, count: count.toString(), label: 'Beğenilenler'.tr());
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ValueListenableBuilder<int>(
                                      valueListenable: ActivityState.instance.savedCount,
                                      builder: (context, count, _) {
                                        return _StatCard(icon: Icons.bookmark, count: count.toString(), label: 'Kaydedilenler'.tr());
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ValueListenableBuilder<int>(
                                      valueListenable: ActivityState.instance.eventsCount,
                                      builder: (context, count, _) {
                                        return _StatCard(icon: Icons.event_available, count: count.toString(), label: 'Etkinlikler'.tr());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Saved Items
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KAYDEDİLENLER'.tr(),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _MiniListItem(
                                icon: Icons.bookmark, 
                                title: 'Kaydedilen Haberler'.tr(),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedContentScreen()));
                                },
                              ),
                              _MiniListItem(
                                icon: Icons.favorite, 
                                title: 'Favori Etkinlikler'.tr(),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedContentScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Support Summary
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DESTEK ÖZETİ'.tr(),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _MiniListItem(icon: Icons.volunteer_activism, title: 'Bağış Geçmişim'.tr()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Footer / Logout
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: AppColors.accent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Çıkış Yap'.tr(),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'v1.0.4',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    // ignore: unused_element_parameter
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border(left: BorderSide(color: AppColors.accent, width: 4))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;

  const _StatCard({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MiniListItem({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}