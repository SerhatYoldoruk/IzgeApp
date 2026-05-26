import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notification_settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/account_security_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/about_us_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:izge_app_frontend/core/theme/theme_controller.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/language_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<Map<String, dynamic>>? _userProfileFuture;

  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onThemeChanged);
    LanguageController.instance.addListener(_onLanguageChanged);
    _refreshProfile();
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    LanguageController.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _refreshProfile() {
    if (mounted) {
      setState(() {
        _userProfileFuture = _fetchUserProfile();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
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
      return {
        'name': user.userMetadata?['name'] ?? 'Kullanıcı',
        'email': user.email ?? '',
        'avatar_url': user.userMetadata?['avatar_url'] ?? '',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ayarlar'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data ?? {};
          final name = userData['name'] ?? userData['full_name'] ?? 'Ahmet Yılmaz';
          final email = userData['email'] ?? Supabase.instance.client.auth.currentUser?.email ?? 'ahmet.yilmaz@example.com';
          final avatarUrl = userData['avatar_url'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceElevated,
                          border: Border.all(color: const Color(0xFF1A8025), width: 2),
                        ),
                        child: ClipOval(
                          child: avatarUrl.isNotEmpty
                              ? Image.network(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Icon(
                                    Icons.person,
                                    size: 32,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 32,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF1A8025)),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.border.withOpacity(0.3),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => const EditProfileScreen()),
                          );
                          _refreshProfile();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSettingsGroup(
                  title: 'Genel'.tr(),
                  items: [
                    _buildSettingsItem(
                      icon: Icons.notifications,
                      title: 'Bildirim Ayarları'.tr(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const NotificationSettingsScreen()),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: 'Dil Tercihi'.tr(),
                      trailingText: LanguageController.instance.isTurkish ? 'Türkçe' : 'English',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const LanguageScreen()),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: ThemeController.instance,
                      builder: (ctx, child) {
                        return _buildSettingsItem(
                          icon: Icons.dark_mode,
                          title: 'Karanlık Mod'.tr(),
                          trailingWidget: Switch(
                            value: ThemeController.instance.isDarkMode,
                            onChanged: (value) {
                              ThemeController.instance.toggleTheme();
                            },
                            activeThumbColor: const Color(0xFF1A8025),
                          ),
                          onTap: () {
                            ThemeController.instance.toggleTheme();
                          },
                          isLast: true,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingsGroup(
                  title: 'Güvenlik'.tr(),
                  items: [
                    _buildSettingsItem(
                      icon: Icons.lock,
                      title: 'Hesap Güvenliği'.tr(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const AccountSecurityScreen()),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.policy,
                      title: 'Gizlilik Politikası'.tr(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const PrivacyPolicyScreen()),
                        );
                      },
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingsGroup(
                  title: 'Diğer'.tr(),
                  items: [
                    _buildSettingsItem(
                      icon: Icons.info,
                      title: 'Hakkımızda'.tr(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const AboutUsScreen()),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: 'Yardım Merkezi'.tr(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => const HelpCenterScreen()),
                        );
                      },
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Color(0xFFFFB4AB)),
                    label: Text(
                      'Çıkış Yap'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFB4AB),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      side: BorderSide(color: const Color(0xFFFFB4AB).withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A8025),
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF1A8025)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (trailingText != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            trailingText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailingWidget != null)
                    trailingWidget
                  else
                    Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.border.withOpacity(0.3),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}