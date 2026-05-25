import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/create_request_screen.dart';

class NewRequestTypesScreen extends StatelessWidget {
  const NewRequestTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Yeni Talep Türleri',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32).copyWith(bottom: 24),
            child: Column(
              children: [
                // Category Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    if (isWide) {
                      return Row(
                        children: [
                          Expanded(child: Column(children: [
                            _buildCard(Icons.medical_services, 'Tıbbi Cihaz Desteği', 'Tekerlekli sandalye, işitme cihazı ve diğer medikal ihtiyaçlar.'),
                            const SizedBox(height: 16),
                            _buildCard(Icons.psychology, 'Psikolojik Danışmanlık', 'Uzman psikologlardan ücretsiz terapi ve destek seansları.'),
                          ])),
                          const SizedBox(width: 16),
                          Expanded(child: Column(children: [
                            _buildCard(Icons.school, 'Eğitim Bursu', 'Öğrenciler için aylık burs veya kırtasiye/materyal yardımı.'),
                            const SizedBox(height: 16),
                            _buildCard(Icons.gavel, 'Hukuki Yardım', 'Pro bono avukatlarımızdan hukuki danışmanlık hizmeti.'),
                          ])),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildCard(Icons.medical_services, 'Tıbbi Cihaz Desteği', 'Tekerlekli sandalye, işitme cihazı ve diğer medikal ihtiyaçlar.'),
                          const SizedBox(height: 16),
                          _buildCard(Icons.school, 'Eğitim Bursu', 'Öğrenciler için aylık burs veya kırtasiye/materyal yardımı.'),
                          const SizedBox(height: 16),
                          _buildCard(Icons.psychology, 'Psikolojik Danışmanlık', 'Uzman psikologlardan ücretsiz terapi ve destek seansları.'),
                          const SizedBox(height: 16),
                          _buildCard(Icons.gavel, 'Hukuki Yardım', 'Pro bono avukatlarımızdan hukuki danışmanlık hizmeti.'),
                        ],
                      );
                    }
                  },
                ),
                
                SizedBox(height: 32),
                
                // Requirements Guide
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated, // surface-container-low
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withOpacity(0.2)), // outline-variant/20
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: AppColors.textSecondary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Gerekli Belgeler Rehberi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildRequirementItem('Tıbbi Cihaz başvuruları için doktor raporu zorunludur.'),
                      const SizedBox(height: 12),
                      _buildRequirementItem('Eğitim bursu için güncel öğrenci belgesi ve gelir beyanı eklenmelidir.'),
                      const SizedBox(height: 12),
                      _buildRequirementItem('Hukuki yardım taleplerinde vaka özeti PDF veya JPEG formatında yüklenebilir.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border.withOpacity(0.2)),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateRequestScreen()),
                );
              },
              icon: const Icon(Icons.add_circle, color: Color(0xFF003908)), // on-primary
              label: const Text(
                'Yeni Talep Oluştur',
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
                elevation: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant/30
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Icon(
              icon,
              size: 100,
              color: const Color(0xFF7ADC75).withOpacity(0.05), // primary
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A8025), // primary-container
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                    ),
                  ],
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
                        color: Color(0xFF7ADC75), // primary
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Color(0xFF7ADC75), // primary
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
