import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/tax_receipts_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/monthly_donations_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donation_transparency_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/contact_support_screen.dart';

class DonationsHelpScreen extends StatelessWidget {
  const DonationsHelpScreen({super.key});

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
          'Bağışlar'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contextual Intro
            Text(
              'Bağış işlemleriniz, vergi süreçleri ve fonların kullanımı hakkında detaylı bilgilere buradan ulaşabilirsiniz.'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary, // on-surface-variant
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            // Help Topic Cards
            _buildTopicCard(
              context: context,
              icon: Icons.receipt_long,
              title: 'Vergi Makbuzları'.tr(),
              subtitle: 'Makbuz talepleri ve vergi indirim süreçleri'.tr(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaxReceiptsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildTopicCard(
              context: context,
              icon: Icons.autorenew,
              title: 'Aylık Bağışlar'.tr(),
              subtitle: 'Düzenli bağış başlatma, düzenleme ve iptali'.tr(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MonthlyDonationsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildTopicCard(
              context: context,
              icon: Icons.explore,
              title: 'Bağışlar Nereye Gidiyor?'.tr(),
              subtitle: 'Şeffaflık raporları ve güncel projelerimiz'.tr(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonationTransparencyScreen()),
                );
              },
            ),
            
            SizedBox(height: 32),
            
            // Support Action Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border), // outline-variant
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration( color: AppColors.border, // surface-container-highest
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.support_agent, color: Color(0xFF7ADC75), size: 32), // primary
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Başka bir sorunuz mu var?'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Destek ekibimiz tüm soru ve sorunlarınız için size yardımcı olmaya hazır.'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7ADC75), // primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Destek Ekibine Ulaşın'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003908), // on-primary
                        ),
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface, // surface-container
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent), // for hover effect emulation if needed
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF1A8025), // primary-container
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFFD3FFC8)), // on-primary-container
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
