import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class EmailVerificationFailedScreen extends StatelessWidget {
  const EmailVerificationFailedScreen({super.key});

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
          'Teknik Destek'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Waves Mock (Subtle Glow)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 1.5,
                    colors: [Color(0xFF93000A), Colors.transparent], // error-container
                    stops: [0.0, 0.6],
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Error Visual
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB4AB).withOpacity(0.2), // error
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFB4AB).withOpacity(0.2),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            color: AppColors.border, // surface-container-highest
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFB4AB).withOpacity(0.3), width: 4), // error/30
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF93000A).withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Icon(Icons.error, color: Color(0xFFFFB4AB), size: 64),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    
                    // Typography Stack
                    Text(
                      'Doğrulama Başarısız'.tr(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Doğrulama kodu geçersiz veya süresi dolmuş olabilir. Lütfen kodunuzu kontrol edin veya yeni bir kod talep edin.'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    
                    // Feedback UI Element
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated.withOpacity(0.6), // surface-container-low/60
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF93000A).withOpacity(0.3), // error-container/30
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.timer_off, color: Color(0xFFFFB4AB), size: 20), // error
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kodun Süresi Doldu'.tr(),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFFB4AB)), // error
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Güvenliğiniz için kodlar 5 dakika geçerlidir.'.tr(),
                                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Action Stack
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context), // Typically goes back to input screen
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary, // on-surface
                          foregroundColor: AppColors.background, // surface
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        child: Text('Yeni Kod Gönder'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary, // on-surface-variant
                          side: BorderSide(color: const Color(0xFF899484).withOpacity(0.3)), // outline/30
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Geri Dön'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
