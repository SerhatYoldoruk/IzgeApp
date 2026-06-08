import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/my_events_screen.dart';
import 'package:izge_app_frontend/features/navigation/presentation/widgets/custom_drawer.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donation_history_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/past_requests_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/personal_info_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/settings_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/accessibility_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      drawer: const CustomDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            final canPop = Navigator.canPop(context);
            return IconButton(
              icon: Icon(canPop ? Icons.arrow_back : Icons.menu),
              color: AppColors.textPrimary,
              onPressed: () {
                if (canPop) {
                  Navigator.pop(context);
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
            );
          },
        ),
        title: Text(
          'Profilim'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.3),
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColors.surface,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data ?? {};
          final name =
              userData['full_name'] ?? userData['name'] ?? 'Ahmet Yılmaz';

          // DÜZELTİLDİ: Veritabanındaki gerçek sütun adın 'avatar_url' olduğu için burası eşitlendi
          final avatarUrl = userData['avatar_url'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
            child: Column(
              children: [
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
                      Container(
                        height: 96,
                        width: double.infinity,
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            GestureDetector(
                              onLongPress: () => _showImageOverlay(avatarUrl),
                              child: Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.surface,
                                    width: 4,
                                  ),
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
                                  child: avatarUrl.isNotEmpty
                                      ? Image.network(
                                          avatarUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  size: 48,
                                                  color: AppColors.textSecondary,
                                                );
                                              },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 48,
                                          color: AppColors.textSecondary,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A8025).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: AppColors.accent,
                                    size: 16,
                                  ),
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
                          ],
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
                          // DÜZELTİLDİ: Burası zaten await'liydi, tetikleme mekanizması tıkır tıkır çalışacak
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalInfoScreen(),
                            ),
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
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DonationHistoryScreen(),
                            ),
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
                            MaterialPageRoute(
                              builder: (context) => const MyEventsScreen(),
                            ),
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
                            MaterialPageRoute(
                              builder: (context) => const PastRequestsScreen(),
                            ),
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
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: Icons.accessibility_new,
                        title: 'Erişilebilirlik'.tr(),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccessibilityScreen(),
                            ),
                          );
                          _refreshProfile();
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.settings,
                        title: 'Ayarlar'.tr(),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                          _refreshProfile();
                        },
                        iconColor: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
              child: Icon(icon, color: effectiveIconColor, size: 20),
            ),
            const SizedBox(width: 16),
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
    return Container(height: 1, color: AppColors.border.withOpacity(0.3));
  }
}
