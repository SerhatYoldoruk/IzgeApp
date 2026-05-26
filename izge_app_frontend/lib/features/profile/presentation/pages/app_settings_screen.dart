import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/about_us_screen.dart';
// import 'package:izge_app_frontend/features/profile/presentation/pages/account_security_screen.dart'; // From existing
// import 'package:izge_app_frontend/features/profile/presentation/pages/notification_settings_screen.dart'; // We might create a new one or use existing

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _darkModeEnabled = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, // deep dark background
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Uygulama Ayarları',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildSectionHeader('Tercihler', 0),
          _buildAnimatedCard(
            index: 1,
            child: Column(
              children: [
                _buildToggleItem(
                  icon: Icons.notifications_active_outlined,
                  title: 'Anlık Bildirimler',
                  subtitle: 'Yeni etkinlikler ve duyurular',
                  value: _pushNotificationsEnabled,
                  onChanged: (val) => setState(() => _pushNotificationsEnabled = val),
                ),
                _buildDivider(),
                _buildToggleItem(
                  icon: Icons.email_outlined,
                  title: 'E-posta Bildirimleri',
                  subtitle: 'Aylık bülten ve özetler',
                  value: _emailNotificationsEnabled,
                  onChanged: (val) => setState(() => _emailNotificationsEnabled = val),
                ),
                _buildDivider(),
                _buildToggleItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Karanlık Tema',
                  subtitle: 'Sistem temasına uyumlu',
                  value: _darkModeEnabled,
                  onChanged: (val) => setState(() => _darkModeEnabled = val),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          _buildSectionHeader('Güvenlik', 2),
          _buildAnimatedCard(
            index: 3,
            child: Column(
              children: [
                _buildNavigationItem(
                  icon: Icons.lock_outline,
                  title: 'Şifre ve Güvenlik',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildNavigationItem(
                  icon: Icons.shield_outlined,
                  title: 'İki Adımlı Doğrulama (2FA)',
                  onTap: () {},
                  trailingText: 'Kapalı',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('Yasal ve Destek', 4),
          _buildAnimatedCard(
            index: 5,
            child: Column(
              children: [
                _buildNavigationItem(
                  icon: Icons.gavel_outlined,
                  title: 'Gizlilik ve KVKK',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                    );
                  },
                ),
                _buildDivider(),
                _buildNavigationItem(
                  icon: Icons.info_outline,
                  title: 'Uygulama Hakkında',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  },
                  trailingText: 'v1.0.0',
                ),
              ],
            ),
          ),

          SizedBox(height: 40),
          
          _buildAnimatedCard(
            index: 6,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              splashColor: const Color(0xFFFFB4AB).withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surface, // surface-container
                  border: Border.all(color: const Color(0xFF93000A).withOpacity(0.3)), // error-container
                ),
                child: const Text(
                  'Oturumu Kapat',
                  style: TextStyle(
                    color: Color(0xFFFFB4AB), // error color
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int index) {
    return _buildAnimatedCard(
      index: index,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF899484), // outline color / secondary
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    // Calculate animation delay based on index for staggered effect
    final double start = (index * 0.1).clamp(0.0, 1.0);
    final double end = (start + 0.4).clamp(0.0, 1.0);
    
    final Animation<double> slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
    
    final Animation<double> fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, childWidget) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, slideAnimation.value),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: value ? const Color(0xFF1A8025).withOpacity(0.15) : AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: value ? Color(0xFF7ADC75) : AppColors.textSecondary,
                size: 22,
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
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: value,
              activeTrackColor: const Color(0xFF7ADC75),
              inactiveTrackColor: AppColors.border,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFF7ADC75).withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration( color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.border, // surface-variant
      margin: const EdgeInsets.only(left: 64, right: 16),
    );
  }
}
