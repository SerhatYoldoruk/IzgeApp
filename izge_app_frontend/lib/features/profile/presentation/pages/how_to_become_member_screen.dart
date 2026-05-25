import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class HowToBecomeMemberScreen extends StatelessWidget {
  const HowToBecomeMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary), // on-surface-variant equivalent
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'İzge App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF96F98E), // primary-fixed
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // Balance for center title
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 120), // Bottom padding for sticky CTA
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  'Nasıl Üye Olunur?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Aramıza katılmak için aşağıdaki adımları takip ederek üyelik sürecinizi tamamlayabilirsiniz.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Timeline Steps
                _buildTimelineStep(
                  stepNumber: '1',
                  title: 'Başvuru Formu',
                  description: 'Sistem üzerinden dijital üyelik başvuru formunu eksiksiz ve doğru bilgilerle doldurun.',
                  icon: Icons.edit_document,
                  isLast: false,
                  isActive: false,
                ),
                _buildTimelineStep(
                  stepNumber: '2',
                  title: 'Belge Yükleme',
                  description: 'Kimlik fotokopisi ve dernek tüzüğünce talep edilen ek belgelerinizi sisteme güvenle yükleyin.',
                  icon: Icons.upload_file,
                  isLast: false,
                  isActive: false,
                ),
                _buildTimelineStep(
                  stepNumber: '3',
                  title: 'Değerlendirme Süreci',
                  description: 'Yönetim kurulumuz başvurunuzu ve belgelerinizi inceler. Bu süreç uygulama üzerinden takip edilebilir.',
                  icon: Icons.rule,
                  isLast: false,
                  isActive: false,
                ),
                _buildTimelineStep(
                  stepNumber: '4',
                  title: 'Üyelik Aktifleşmesi',
                  description: 'Onay sonrası giriş aidatınızı uygulama içinden ödeyerek İzge App\'in tüm özelliklerini kullanmaya başlayın.',
                  icon: Icons.check_circle,
                  isLast: true,
                  isActive: true, // The final step is highlighted
                ),
              ],
            ),
          ),
          
          // Bottom Action Button (Fixed)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withOpacity(0.95),
                    AppColors.background.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Başvuru formuna yönlendiriliyorsunuz...'),
                      backgroundColor: Color(0xFF1A8025),
                    ),
                  );
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7ADC75), // primary
                      foregroundColor: const Color(0xFF003908), // on-primary
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26), // full pill
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFF7ADC75).withOpacity(0.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hemen Başvur',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required bool isLast,
    required bool isActive,
  }) {
    final iconBgColor = isActive ? const Color(0xFF7ADC75) : const Color(0xFF1A8025).withOpacity(0.2); // primary vs primary-container/20
    final iconColor = isActive ? const Color(0xFF003908) : const Color(0xFF96F98E); // on-primary vs primary-fixed
    final iconBorderColor = isActive ? const Color(0xFF96F98E) : const Color(0xFF7ADC75).withOpacity(0.3); // primary-fixed vs primary/30
    
    final cardBgColor = isActive ? AppColors.surfaceElevated : AppColors.surface; // surface-container-high vs surface-container
    final cardBorderColor = isActive ? const Color(0xFF7ADC75).withOpacity(0.3) : AppColors.border; // primary/30 vs surface-variant
    
    final titleColor = isActive ? AppColors.textPrimary : Color(0xFF96F98E); // on-surface vs primary-fixed

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline visual
          Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: iconBorderColor, width: isActive ? 2 : 1),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: const Color(0xFF7ADC75).withOpacity(0.3),
                      blurRadius: 20,
                    )
                  ] : [
                    BoxShadow(
                      color: const Color(0xFF7ADC75).withOpacity(0.15),
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.border, // surface-container-highest / surface-variant
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                )
              else
                SizedBox(height: 40), // Padding below last item instead of line
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24), // spacing between steps
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cardBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$stepNumber. $title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
