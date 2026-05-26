import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class RightsObligationsScreen extends StatelessWidget {
  const RightsObligationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF96F98E)), // primary-fixed
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Haklar ve Yükümlülükler'.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF96F98E), // primary-fixed
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // Balance for center title
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro
            Text(
              'Üye Hakları ve Sorumlulukları'.tr(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Dernek tüzüğüne göre, yönetim kurulu ve normal üyelerin temel hak ve yükümlülükleri aşağıda özetlenmiştir.'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Section 1: Haklar
            _buildSectionHeader(Icons.gavel, 'Temel Haklar'.tr(), const Color(0xFF7ADC75)),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Genel Kurul ve Oy Hakkı'.tr(),
              description: 'Tüm asil üyeler genel kurula katılma, söz alma ve dernek organları için oy kullanma hakkına sahiptir.'.tr(),
              icon: Icons.how_to_vote,
              colorScheme: const Color(0xFF1A8025), // primary-container
              iconColor: const Color(0xFF96F98E), // primary-fixed
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              title: 'Bilgi Edinme'.tr(),
              description: 'Üyeler, derneğin faaliyetleri, mali durumu ve alınan kararlar hakkında düzenli olarak bilgilendirilme hakkına sahiptir.'.tr(),
              icon: Icons.info,
              colorScheme: AppColors.border, // surface-variant
              iconColor: const Color(0xFF7ADC75), // primary
            ),
            
            SizedBox(height: 32),
            
            // Section 2: Yükümlülükler
            _buildSectionHeader(Icons.assignment_ind, 'Yükümlülükler'.tr(), AppColors.textSecondary),
            SizedBox(height: 16),
            _buildInfoCard(
              title: 'Tüzüğe Uygunluk'.tr(),
              description: 'Her üye dernek tüzüğüne, genel kurul ve yönetim kurulu kararlarına uymakla yükümlüdür.'.tr(),
              icon: Icons.menu_book,
              colorScheme: AppColors.surfaceElevated, // secondary-container
              iconColor: AppColors.textSecondary, // secondary-fixed-dim
            ),
            SizedBox(height: 12),
            _buildInfoCard(
              title: 'Aidat Sorumluluğu'.tr(),
              description: 'Üyeler, genel kurul tarafından belirlenen yıllık üyelik aidatlarını zamanında ödemekle yükümlüdür. Aksi halde üyelik askıya alınabilir.'.tr(),
              icon: Icons.payments,
              colorScheme: AppColors.surfaceElevated, // secondary-container
              iconColor: AppColors.textSecondary, // secondary-fixed-dim
            ),
            SizedBox(height: 12),
            _buildInfoCard(
              title: 'Dernek İtibarını Koruma'.tr(),
              description: 'Üyeler, derneğin vizyon ve misyonuna aykırı davranışlardan kaçınmalı ve derneğin itibarını zedeleyici faaliyetlerde bulunmamalıdır.'.tr(),
              icon: Icons.verified_user,
              colorScheme: AppColors.surfaceElevated, // secondary-container
              iconColor: AppColors.textSecondary, // secondary-fixed-dim
            ),
            
            SizedBox(height: 32),
            
            // Bottom Action Area
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.surface, AppColors.surfaceElevated], // surface-container to surface-container-high
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border), // surface-variant
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detaylı Bilgi'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dernek tüzüğünün tamamına ve tüm hukuki detaylara mevzuat sayfasından ulaşabilirsiniz.'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.picture_as_pdf, color: AppColors.textPrimary, size: 20),
                      label: Text(
                        'Tüzüğü İndir'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF899484)), // outline
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color colorScheme,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)), // outline-variant
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
