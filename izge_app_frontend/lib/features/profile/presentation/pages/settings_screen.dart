import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/theme/theme_controller.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/about_us_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/account_security_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/language_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notification_settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/personal_info_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    _refreshProfile();
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
        'full_name': user.userMetadata?['name'] ?? 'Kullanıcı',
        'email': user.email ?? '',
        'avatar_url': user.userMetadata?['avatar_url'] ?? '',
      };
    }
  }

  OverlayEntry? _overlayEntry;

  void _showImageOverlay(String url) {
    if (url.isEmpty) return;

    // Google resimlerinin kalitesini artırmak için =s96-c kısmını =s1024-c yapıyoruz
    String highResUrl = url;
    if (highResUrl.contains('googleusercontent.com') && highResUrl.contains('=s96-c')) {
      highResUrl = highResUrl.replaceAll('=s96-c', '=s1024-c');
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideImageOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: InteractiveViewer(
                        panEnabled: true,
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: ClipOval(
                          child: Image.network(
                            highResUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideImageOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface, // surface-container
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ayarlar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Profile Summary Card
            FutureBuilder<Map<String, dynamic>>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                final userData = snapshot.data ?? {};
                final name =
                    userData['full_name'] ??
                    userData['name'] ??
                    'Yükleniyor...';
                final email = userData['email'] ?? '';
                final avatarUrl = userData['avatar_url'] ?? '';

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface, // surface-container
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
                      GestureDetector(
                        onLongPress: () => _showImageOverlay(avatarUrl),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors
                                .surfaceElevated, // surface-container-high
                            border: Border.all(
                              color: const Color(0xFF1A8025),
                              width: 2,
                            ), // primary-container
                          ),
                          child: ClipOval(
                            child: avatarUrl.isNotEmpty
                                ? Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(
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
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                        icon: Icon(
                          Icons.edit,
                          color: Color(0xFF1A8025),
                        ), // primary-container
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.border.withOpacity(
                            0.3,
                          ), // surface-variant/30
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalInfoScreen(),
                            ),
                          );
                          _refreshProfile();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Settings Groups
            _buildSettingsGroup(
              title: 'Genel',
              items: [
                _buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'Bildirim Ayarları',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'Dil Tercihi',
                  trailingText: 'Türkçe',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageScreen(),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: ThemeController.instance,
                  builder: (context, child) {
                    return _buildSettingsItem(
                      icon: Icons.dark_mode,
                      title: 'Karanlık Mod',
                      trailingWidget: Switch(
                        value: ThemeController.instance.isDarkMode,
                        onChanged: (value) {
                          ThemeController.instance.toggleTheme();
                        },
                        activeColor: const Color(0xFF1A8025),
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
              title: 'Güvenlik',
              items: [
                _buildSettingsItem(
                  icon: Icons.lock,
                  title: 'Hesap Güvenliği',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSecurityScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.policy,
                  title: 'Gizlilik Politikası',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSettingsGroup(
              title: 'Diğer',
              items: [
                _buildSettingsItem(
                  icon: Icons.info,
                  title: 'Hakkımızda',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Yardım Merkezi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen(),
                      ),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: const Color(0xFFD32F2F),
                ), // error dark red
                label: const Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD32F2F), // error dark red
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      AppColors.surfaceElevated, // surface-container-high
                  side: BorderSide(
                    color: const Color(0xFFD32F2F).withOpacity(0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
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
                color: Color(0xFF1A8025), // primary-container
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
                      color: AppColors.border, // surface-container-highest
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF1A8025),
                    ), // primary-container
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
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (trailingText != null) ...[
                          SizedBox(height: 2),
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
            color: AppColors.border.withOpacity(0.3), // outline-variant/30
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
