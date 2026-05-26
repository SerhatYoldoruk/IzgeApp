import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class ForgotPasswordFailedScreen extends StatefulWidget {
  const ForgotPasswordFailedScreen({super.key});

  @override
  State<ForgotPasswordFailedScreen> createState() => _ForgotPasswordFailedScreenState();
}

class _ForgotPasswordFailedScreenState extends State<ForgotPasswordFailedScreen> {
  bool _isLoading = false;

  void _handleRetry() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Subtle Background Elements (Atmospheric)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: -80,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: const Color(0xFF7ADC75).withOpacity(0.05), // primary
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7ADC75).withOpacity(0.05), blurRadius: 100, spreadRadius: 50),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -80,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                color: const Color(0xFF93000A).withOpacity(0.05), // error-container
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF93000A).withOpacity(0.05), blurRadius: 120, spreadRadius: 60),
                ],
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
                    // Central Error Icon Section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Abstract Glow Background
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF93000A).withOpacity(0.2), // error-container
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF93000A).withOpacity(0.2), blurRadius: 60, spreadRadius: 20),
                            ],
                          ),
                        ),
                        // Glass Effect Container
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                            boxShadow: const [
                              BoxShadow(color: Color(0x4D93000A), blurRadius: 40), // error-glow
                            ],
                          ),
                          child: Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF93000A), // error-container
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(Icons.mail_lock, color: Color(0xFFFFB4AB), size: 48), // error
                                ),
                                // Badge Overlay
                                Positioned(
                                  bottom: -8,
                                  right: -8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFB4AB), // error
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.background, width: 4),
                                    ),
                                    child: Icon(Icons.close, color: Color(0xFF690005), size: 20), // on-error
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    
                    // Content Group
                    Text(
                      'Bağlantı Gönderilemedi'.tr(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Bir hata oluştuğu için şifre sıfırlama bağlantısı e-posta adresinize gönderilemedi. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Actions Group
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRetry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary, // on-surface
                          foregroundColor: AppColors.background, // background
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          disabledBackgroundColor: AppColors.textPrimary.withOpacity(0.8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isLoading)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                              )
                            else
                              Icon(Icons.refresh, size: 24),
                            SizedBox(width: 8),
                            Text(
                              _isLoading ? 'Deneniyor...'.tr() : 'Tekrar Dene'.tr(),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary, // on-surface-variant
                          side: BorderSide(color: AppColors.border), // outline-variant
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Giriş Ekranına Dön'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
