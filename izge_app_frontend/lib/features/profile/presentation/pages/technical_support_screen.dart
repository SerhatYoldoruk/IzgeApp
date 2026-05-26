import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/connection_issues_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/other_issues_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/device_compatibility_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/login_issues_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/bug_report_support_screen.dart';

class TechnicalSupportScreen extends StatelessWidget {
  const TechnicalSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Teknik Destek'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Hero Section
            Text(
              'Nasıl yardımcı olabiliriz?'.tr(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Uygulama ile ilgili teknik sorunlarınızı çözmek için buradayız.'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 32),
            
            // Search Bar
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Sorununuzu arayın (örn. giriş hatası)'.tr(),
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surfaceElevated, // surface-container-high
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Help Topics Bento Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                final card1 = _buildTopicCard(
                  icon: Icons.login,
                  title: 'Giriş Problemleri'.tr(),
                  subtitle: 'Şifremi unuttum, hesabıma erişemiyorum veya doğrulama kodu gelmiyor.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginIssuesScreen()),
                    );
                  },
                );
                
                final card2 = _buildTopicCard(
                  icon: Icons.bug_report,
                  title: 'Hata Bildirimi'.tr(),
                  subtitle: 'Uygulama çöküyor, ekran donuyor veya beklenmedik bir hata mesajı alıyorum.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BugReportSupportScreen()),
                    );
                  },
                );
                
                final card3 = _buildTopicCard(
                  icon: Icons.devices,
                  title: 'Cihaz ve Sistem Uyumluluğu'.tr(),
                  subtitle: 'Uygulamanın sürümü, işletim sistemi gereksinimleri ve performans ayarları hakkında destek alın.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeviceCompatibilityScreen()),
                    );
                  },
                  isHorizontal: true,
                );
                
                final card4 = _buildTopicCard(
                  icon: Icons.wifi_off,
                  title: 'Bağlantı Sorunları'.tr(),
                  subtitle: 'İnternet bağlantısı hatası, veri senkronizasyonu veya yavaş yüklenme problemleri.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConnectionIssuesScreen()),
                    );
                  },
                );
                
                final card5 = _buildTopicCard(
                  icon: Icons.help,
                  title: 'Diğer Sorunlar'.tr(),
                  subtitle: 'Yukarıdaki kategorilere uymayan diğer tüm teknik sorunlar için destek talebi oluşturun.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtherIssuesScreen()),
                    );
                  },
                );
                
                if (isWide) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: card1),
                          const SizedBox(width: 16),
                          Expanded(child: card2),
                        ],
                      ),
                      const SizedBox(height: 16),
                      card3, // full width
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: card4),
                          const SizedBox(width: 16),
                          Expanded(child: card5),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      card1,
                      const SizedBox(height: 16),
                      card2,
                      const SizedBox(height: 16),
                      card3,
                      const SizedBox(height: 16),
                      card4,
                      const SizedBox(height: 16),
                      card5,
                    ],
                  );
                }
              },
            ),
            
            SizedBox(height: 32),
            
            // Contact Support CTA
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-high
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF899484).withOpacity(0.2)), // outline/20
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Aradığınızı bulamadınız mı?'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Destek ekibimizle doğrudan iletişime geçerek detaylı yardım alabilirsiniz.'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
                        );
                      },
                      icon: const Icon(Icons.support_agent, color: Color(0xFF00530F)), // on-primary-fixed-variant
                      label: Text(
                        'Canlı Destek Başlat'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00530F), // on-primary-fixed-variant
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7ADC75), // primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF7ADC75).withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                      ),
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

  Widget _buildTopicCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isHorizontal = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated.withOpacity(0.4), // glass-card
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF899484).withOpacity(0.1)),
          ),
          child: isHorizontal
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration( color: AppColors.surface, // surface-container
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFF7ADC75)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration( color: AppColors.surface, // surface-container
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFF7ADC75)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
