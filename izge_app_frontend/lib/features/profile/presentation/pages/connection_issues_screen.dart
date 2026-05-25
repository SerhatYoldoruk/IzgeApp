import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/contact_support_screen.dart';

class ConnectionIssuesScreen extends StatelessWidget {
  const ConnectionIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceElevated, // surface-container-low
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Teknik Destek',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.contact_support, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title & Intro
            Text(
              'Bağlantı Sorunları',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Uygulama ile ilgili bağlantı problemlerini çözmek için aşağıdaki adımları kontrol edebilirsiniz.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Troubleshoot Grid
            _buildLargeCard(
              icon: Icons.wifi_off,
              title: 'İnternet Bağlantısı Kontrolü',
              description: 'Cihazınızın aktif bir Wi-Fi veya hücresel veri ağına bağlı olduğundan emin olun. Tarayıcınız üzerinden bir web sitesi açarak bağlantınızı test edebilirsiniz.',
              bullets: [
                'Modeminizi yeniden başlatın.',
                'Hücresel veriyi kapatıp açın.',
                'Uçak modunun kapalı olduğunu doğrulayın.',
              ],
            ),
            const SizedBox(height: 16),
            
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final syncCard = _buildSmallCard(
                  icon: Icons.sync_problem,
                  title: 'Veri Senkronizasyonu',
                  description: 'Bilgileriniz güncellenmiyorsa, manuel senkronizasyon yapmayı deneyin. Ayarlar menüsünden \'Şimdi Senkronize Et\' seçeneğini kullanabilirsiniz.',
                );
                final serverCard = _buildSmallCard(
                  icon: Icons.dns,
                  title: 'Sunucu Durumu',
                  description: 'Bazen sorun bizim tarafımızda olabilir. Planlı bakım veya sunucu kesintileri durumunda sosyal medya hesaplarımızdan duyuru yapmaktayız.',
                );

                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: syncCard),
                      const SizedBox(width: 16),
                      Expanded(child: serverCard),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      syncCard,
                      const SizedBox(height: 16),
                      serverCard,
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 32),

            // Support Contact CTA
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant
              ),
              child: Column(
                children: [
                  Text(
                    'Sorun devam ediyor mu?',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                        );
                      },
                      icon: const Icon(Icons.headset_mic, color: Color(0xFF003908)),
                      label: const Text(
                        'Destek Ekibine Ulaşın',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003908),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A8025), // primary-container (actually uses green in HTML: #1a8025 but text is on-primary, let's use the exact color from HTML)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 4,
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

  Widget _buildLargeCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> bullets,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-high
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -48,
            right: -48,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7ADC75).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7ADC75).withOpacity(0.1), blurRadius: 80),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF1A8025), // primary-container
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFFD3FFC8)),
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
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: bullets.map((bullet) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                              Expanded(
                                child: Text(
                                  bullet,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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

  Widget _buildSmallCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-high
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration( color: AppColors.border, // surface-variant
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
            description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
