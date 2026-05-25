import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notification_settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/language_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/account_security_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/about_us_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:izge_app_frontend/core/theme/theme_controller.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            Container(
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
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceElevated, // surface-container-high
                      border: Border.all(color: const Color(0xFF1A8025), width: 2), // primary-container
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCSkoWxLmVWi2QkvkvwjOInHdqxd4DVEM0KQXoH9v1HxOhAx6g2JPYDOcNyDwfuhg6RuYr8SqP3EWLa5f6q0Ept1Gt8V3AZEJ4gVNcbIrpMil4ztZ_QBkclJDjaRS1zJi0yT2Re0HXRSG8MswqeFdufuYzW2jAPNdVokN82TykYVrep801TRAzKE70oFVgr2jJR0xGgSjH1u3mYktA2gSoO2pQQTxjsJAnfjbljoWSaIsuNyd7dW5egqz1n7yENXc2cH_A6zkc_JZvm',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
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
                          'Ahmet Yılmaz',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ahmet.yilmaz@example.com',
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
                    icon: Icon(Icons.edit, color: Color(0xFF1A8025)), // primary-container
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.border.withOpacity(0.3), // surface-variant/30
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
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
                      MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'Dil Tercihi',
                  trailingText: 'Türkçe',
                  onTap: () {},
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
                      MaterialPageRoute(builder: (context) => const AccountSecurityScreen()),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.policy,
                  title: 'Gizlilik Politikası',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
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
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Yardım Merkezi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
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
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: Color(0xFFFFB4AB)), // error
                label: const Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFB4AB), // error
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.surfaceElevated, // surface-container-high
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
                    child: Icon(icon, color: const Color(0xFF1A8025)), // primary-container
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
