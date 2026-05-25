import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/app_settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';
import 'package:izge_app_frontend/core/widgets/social_links_row.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background, // deep dark background
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.surface,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7ADC75).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF7ADC75).withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.diversity_3,
                      color: Color(0xFF7ADC75),
                      size: 36,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'İzge App',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Topluluğa Hoş Geldiniz',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Ana Sayfa',
                    onTap: () => Navigator.pop(context), // Typically goes to home
                  ),
                  const SizedBox(height: 8),
                  _buildDrawerItem(
                    context,
                    icon: Icons.event_rounded,
                    title: 'Etkinlikler',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  _buildDrawerItem(
                    context,
                    icon: Icons.volunteer_activism_rounded,
                    title: 'Bağış ve Destek',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  _buildDrawerItem(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'Yardım Merkezi',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: AppColors.surface, thickness: 1),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings_rounded,
                    title: 'Uygulama Ayarları',
                    onTap: () {
                      Navigator.pop(context); // Close drawer first
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppSettingsScreen()),
                      );
                    },
                    isPrimary: true, // Highlights settings as requested
                  ),
                ],
              ),
            ),
            
            // Footer Version
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Bizi Takip Edin',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  const SocialLinksRow(mainAxisAlignment: MainAxisAlignment.center),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: AppColors.textSecondary, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Sürüm 1.0.0 (Beta)',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.5),
                          fontSize: 12,
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
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: const Color(0xFF7ADC75).withOpacity(0.1),
        highlightColor: const Color(0xFF7ADC75).withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isPrimary ? const Color(0xFF1A8025).withOpacity(0.1) : Colors.transparent,
            border: isPrimary 
                ? Border.all(color: const Color(0xFF7ADC75).withOpacity(0.2))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isPrimary ? Color(0xFF7ADC75) : AppColors.textSecondary,
                size: 24,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isPrimary ? Color(0xFF7ADC75) : AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (isPrimary)
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF7ADC75),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
