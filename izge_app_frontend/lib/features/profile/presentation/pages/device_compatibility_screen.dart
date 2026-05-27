import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class DeviceCompatibilityScreen extends StatelessWidget {
  const DeviceCompatibilityScreen({super.key});

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
        title: const Text(
          'Cihaz Uyumluluğu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF7ADC75),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Version Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border), // outline-variant
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A8025), // primary-container
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified, color: Color(0xFFD3FFC8)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mevcut Versiyon',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'İzge App v1.0.4 (Güncel)',
                          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // OS Requirements Bento Grid
            Text(
              'Sistem Gereksinimleri',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Text(
              'En iyi deneyim için cihazınızın aşağıdaki işletim sistemlerinden birini desteklediğinden emin olun.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),
            
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final androidCard = _buildOSCard(
                  icon: Icons.android,
                  title: 'Android',
                  description: 'Android 8.0 (Oreo) ve üzeri sürümler önerilir.',
                );
                final iosCard = _buildOSCard(
                  icon: Icons.phone_iphone,
                  title: 'iOS',
                  description: 'iOS 13 ve üzeri sürümler önerilir.',
                );
                
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: androidCard),
                      const SizedBox(width: 16),
                      Expanded(child: iosCard),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      androidCard,
                      const SizedBox(height: 16),
                      iosCard,
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 32),
            
            // Performance Info
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed, color: AppColors.textSecondary), // tertiary
                      SizedBox(width: 12),
                      Text(
                        'Performans Bildirimi',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Uygulamamız, düşük donanımlı cihazlarda dahi akıcı çalışacak şekilde optimize edilmiştir. Ancak eski işletim sistemlerinde bazı modern grafiksel geçişler otomatik olarak devre dışı bırakılabilir.\n\nEğer cihazınızda donma veya yavaşlama hissediyorsanız, arka planda çalışan diğer uygulamaları kapatmayı deneyebilirsiniz.',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOSCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-high
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border), // surface-variant
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -16,
            top: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7ADC75).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7ADC75).withOpacity(0.1), blurRadius: 24),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF7ADC75), size: 36),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
