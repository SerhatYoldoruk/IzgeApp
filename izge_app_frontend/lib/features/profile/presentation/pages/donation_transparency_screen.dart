import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class DonationTransparencyScreen extends StatelessWidget {
  const DonationTransparencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'İzge App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Page Header
            Text(
              'Bağışlar Nereye Gidiyor?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Şeffaflık ilkemiz gereği, desteklerinizin her bir kuruşunun nasıl değere dönüştüğünü sizlerle paylaşıyoruz.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Bento Grid Infographic
            _buildLargeCard(
              icon: Icons.medical_services,
              title: 'Tıbbi Cihazlar',
              subtitle: 'Hayati ekipman alımları',
              percentage: 40,
            ),
            const SizedBox(height: 16),
            
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildSmallCard(
                        icon: Icons.school,
                        title: 'Eğitim',
                        subtitle: 'Burslar ve eğitim materyalleri',
                        percentage: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSmallCard(
                        icon: Icons.psychology,
                        title: 'Danışmanlık',
                        subtitle: 'Psikolojik ve hukuki destek',
                        percentage: 20,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            
            // Admin Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border), // surface-container-highest
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.border, // surface-variant
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.admin_panel_settings, color: AppColors.textSecondary, size: 20),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Yönetim & Operasyon',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '%10',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.border, // surface-variant
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary, // tertiary
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kurumsal sürdürülebilirlik için minimum seviyede tutulmaktadır.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Call to Action
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-high
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border), // surface-container-highest
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuC-8Txu8wOxAckSJKzA8KgU22h5Hw8oTNmCtF2MeDj3ecAYqBA7_tuyViRncI6vq2kfjSZYkI1Dc1PYL4F3EazNiD6JH2x0nMTPYoRNZs6Xp3-XQa_7p3oeIRYEfaq-4H_GWqKdspBJGRkZrjyVEPXPBEHQ8twjyP-h3Z3BfGvAckLPfkiDqbBHhvg3qWqHKF5_l4qVGxPusBBwy4pcPaGqO2ILSOEHNTZf8NmUzHYyffF2ujPiYigtyg15iw2jwiWVM9f2tV_vDraN',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 400;
                        final content = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detaylı Şeffaflık Raporu',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Bağımsız denetim kuruluşları tarafından hazırlanan yıllık faaliyet raporlarımızı inceleyebilirsiniz.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                        
                        final button = ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, color: Color(0xFF003908), size: 20), // on-primary
                          label: const Text(
                            'Raporu İndir',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003908), // on-primary
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7ADC75), // primary
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        );
                        
                        if (isWide) {
                          return Row(
                            children: [
                              Expanded(child: content),
                              const SizedBox(width: 16),
                              button,
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              content,
                              const SizedBox(height: 16),
                              button,
                            ],
                          );
                        }
                      },
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

  Widget _buildLargeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border), // surface-container-highest
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '%$percentage',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7ADC75), // primary
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.border, // surface-variant
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7ADC75), // primary
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border), // surface-container-highest
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.border, // surface-container-highest
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.textPrimary, size: 20),
              ),
              Text(
                '%$percentage',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7ADC75), // primary
                ),
              ),
            ],
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
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.border, // surface-variant
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7ADC75).withOpacity(percentage == 30 ? 0.8 : 0.6), // primary with varying opacity
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
