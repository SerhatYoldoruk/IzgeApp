import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/forgot_password_failed_screen.dart';

class ForgotPasswordSupportScreen extends StatelessWidget {
  const ForgotPasswordSupportScreen({super.key});

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
          'Teknik Destek'.tr(),
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
          children: [
            SizedBox(height: 16), // margin top 8 in tailwind = 32px roughly
            
            // Header Section
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration( color: AppColors.border, // surface-variant
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_reset, color: Color(0xFF7ADC75), size: 36), // primary
            ),
            SizedBox(height: 16),
            Text(
              'Şifre Sıfırlama'.tr(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Lütfen hesabınıza kayıtlı e-posta adresinizi girin. Size bir şifre sıfırlama bağlantısı göndereceğiz.'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 32),
            
            // Form Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-high
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E-posta adresiniz'.tr(),
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.mail, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordFailedScreen()),
                  );
                },
                icon: Icon(Icons.send, color: AppColors.background),
                label: Text(
                  'Bağlantı Gönder'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.background,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary, // on-surface
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Back to Login Link
            TextButton.icon(
              onPressed: () => Navigator.pop(context), // Typically would pop back to login
              icon: const Icon(Icons.keyboard_backspace, color: Color(0xFF7ADC75), size: 16),
              label: Text(
                'Giriş Ekranına Dön'.tr(),
                style: const TextStyle(color: Color(0xFF7ADC75), fontSize: 16), // primary
              ),
            ),
          ],
        ),
      ),
    );
  }
}
