import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/personal_info_screen.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/my_events_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donation_history_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/past_requests_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profilim',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.accent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
        ],
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        child: Column(
          children: [
            // User Header Profile Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Background Cover
                  Container(
                    height: 96,
                    width: double.infinity,
                    color: AppColors.border.withOpacity(0.5),
                  ),
                  
                  // Profile Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        // Avatar
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 4),
                            color: AppColors.surfaceElevated,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAKeiZTALeiEQZz8ZTUNghOhfLCbmQKvXX82G5hjf-pO9yg_alqfc4Tep4kQQiSWjPgO6RLvR4RJP94jhdK23_mZu8thCAyi-5P1GARf-zlzXbzPF2yFzDH8-r1NnpB90oRRltDeQmn4kDRe1rfPCFrXdGQ9FQcSKzUrgKlKPMlnLaSkw1xYKN_Fer7pjO0nN6qUH-txgTv3MSvuAfzZe4PicaOufPBJnpW4NqXaNXeWE7H6E-DVJyMPUEn1wWsWjRHYyWQtck09ShJ',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person, size: 48, color: AppColors.textSecondary);
                              },
                            ),

                          ),
                        ),
                        SizedBox(height: 8),
                        
                        // Name
                        Text(
                          'Ahmet Yılmaz',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A8025).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: AppColors.accent, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Gönüllü Üye'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildListTile(
                                icon: Icons.person,
                                title: 'Kişisel Bilgiler'.tr(),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                                  );
                                  _refreshProfile();
                                },
                              ),
                              _buildDivider(),
                              _buildListTile(
                                icon: Icons.volunteer_activism,
                                title: 'Bağış Geçmişim'.tr(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DonationHistoryScreen()),
                                  );
                                },
                              ),
                              _buildDivider(),
                              _buildListTile(
                                icon: Icons.event_available,
                                title: 'Etkinlik Katılımlarım'.tr(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MyEventsScreen()),
                                  );
                                },
                              ),
                              _buildDivider(),
                              _buildListTile(
                                icon: Icons.support_agent,
                                title: 'Taleplerim'.tr(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PastRequestsScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _buildListTile(
                            icon: Icons.settings,
                            title: 'Ayarlar'.tr(),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                              );
                              _refreshProfile();
                            },
                            iconColor: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Social Integration Section
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                'BAĞLI HESAPLAR',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LinkedAccountsScreen()),
                      );
                    },
                    icon: const Icon(Icons.share, color: Color(0xFF1DA1F2)),
                    label: const Text(
                      'X (Twitter)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1DA1F2),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DA1F2).withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: const Color(0xFF1DA1F2).withOpacity(0.2)),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LinkedAccountsScreen()),
                      );
                    },
                    icon: Icon(Icons.add, color: AppColors.textPrimary),
                    label: Text(
                      'Bağla',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.border.withOpacity(0.3)),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: Icons.person,
                        title: 'Kişisel Bilgiler'.tr(),
                        onTap: () async {
                          // DÜZELTİLDİ: Burası zaten await'liydi, tetikleme mekanizması tıkır tıkır çalışacak
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                          );
                          _refreshProfile();
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.volunteer_activism,
                        title: 'Bağış Geçmişim'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DonationHistoryScreen()),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.event_available,
                        title: 'Etkinlik Katılımlarım'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyEventsScreen()),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.support_agent,
                        title: 'Taleplerim'.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PastRequestsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildListTile(
                    icon: Icons.settings,
                    title: 'Ayarlar'.tr(),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                      _refreshProfile();
                    },
                    iconColor: AppColors.textSecondary,
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final effectiveIconColor = iconColor ?? AppColors.accent;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.border.withOpacity(0.3),
    );
  }
}
