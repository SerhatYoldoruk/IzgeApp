import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/request_status_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/new_request_types_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/past_requests_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/live_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/troubleshooting_screen.dart';

class RequestsHelpScreen extends StatelessWidget {
  const RequestsHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Talepler'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nasıl yardımcı olabiliriz?'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Taleplerinizle ilgili sıkça sorulan sorular ve rehberler.'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            
            // Bento Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                final card1 = _buildTopicCard(
                  context: context,
                  icon: Icons.sync,
                  title: 'Talep Durumu Sorgulama'.tr(),
                  subtitle: 'Mevcut taleplerinizin hangi aşamada olduğunu nasıl öğrenebilirsiniz?'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestStatusScreen()),
                    );
                  },
                );
                
                final card2 = _buildTopicCard(
                  context: context,
                  icon: Icons.add_circle,
                  title: 'Yeni Talep Türleri'.tr(),
                  subtitle: 'Sisteme yeni eklenen hizmet talebi kategorileri ve başvuru süreçleri.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewRequestTypesScreen()),
                    );
                  },
                );
                
                final card3 = _buildTopicCard(
                  context: context,
                  icon: Icons.build,
                  title: 'Sorun Giderme'.tr(),
                  subtitle: 'Talep oluştururken hata alıyorsanız, belgeleriniz yüklenmiyorsa veya uygulamanın çökmesi durumunda izlenecek adımlar.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TroubleshootingScreen()),
                    );
                  },
                  isError: true,
                );
                
                final card4 = _buildTopicCard(
                  context: context,
                  icon: Icons.history,
                  title: 'Geçmiş Talepler'.tr(),
                  subtitle: 'Tamamlanmış veya iptal edilmiş taleplerinizin arşivine erişim.'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PastRequestsScreen()),
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
                      card4, // Col span 2
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: card3),
                          const SizedBox(width: 16),
                          Expanded(child: Container()), // Empty space for layout balance
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
                      card4,
                      const SizedBox(height: 16),
                      card3,
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: 32),
            
            // Support Action
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LiveSupportScreen()),
                  );
                },
                icon: const Icon(Icons.headset_mic, color: Color(0xFFD3FFC8)), // on-primary-container
                label: Text(
                  'Canlı Destek Başlat'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD3FFC8), // on-primary-container
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A8025), // primary-container
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isError = false,
  }) {
    final bgColor = AppColors.surfaceElevated; // surface-container-high
    final iconBgColor = isError ? const Color(0xFF93000A).withOpacity(0.2) : AppColors.border; // error-container/20 vs surface-container-highest
    final iconColor = isError ? const Color(0xFFFFB4AB) : const Color(0xFF7ADC75); // error vs primary
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border), // outline-variant
          ),
          child: isError 
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor),
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
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Çözüm Rehberini İncele'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: iconColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: iconColor, size: 16),
                            ],
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
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
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
