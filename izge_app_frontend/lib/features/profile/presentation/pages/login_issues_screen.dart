import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/contact_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/forgot_password_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/email_verification_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/account_recovery_screen.dart';

class LoginIssuesScreen extends StatelessWidget {
  const LoginIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface, // surface-container
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giriş Problemleri'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hesabınıza erişimde yaşadığınız sorunları hızlıca çözmek için aşağıdaki adımları takip edebilirsiniz.'.tr(),
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Issue Card 1
            _buildIssueCard(
              icon: Icons.password,
              iconColor: const Color(0xFFD3FFC8), // on-primary-container
              iconBgColor: const Color(0xFF1A8025), // primary-container
              title: 'Şifremi Unuttum'.tr(),
              description: 'Mevcut şifrenizi hatırlamıyorsanız, sisteme kayıtlı e-posta adresinizi kullanarak yeni bir şifre oluşturabilirsiniz.'.tr(),
              actionButton: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordSupportScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ADC75), // primary
                  foregroundColor: const Color(0xFF003908), // on-primary
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 2,
                ),
                child: Text('Şifre Sıfırlama Bağlantısı Gönder'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Issue Card 2
            _buildIssueCard(
              icon: Icons.mail,
              iconColor: const Color(0xFF7ADC75), // primary
              iconBgColor: AppColors.surfaceElevated, // surface-container-high
              title: 'E-posta Doğrulama Kodu Gelmiyor'.tr(),
              description: "Eğer doğrulama kodu gelen kutunuza düşmediyse, lütfen 'Gereksiz/Spam' klasörünü kontrol edin. Kodun süresi dolmuş olabilir.".tr(),
              actionButton: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmailVerificationSupportScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.border, // surface-container-highest
                  foregroundColor: AppColors.textPrimary, // on-surface
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: Text('Kodu Tekrar Gönder'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Issue Card 3
            _buildIssueCard(
              icon: Icons.lock,
              iconColor: const Color(0xFFFFDAD6), // on-error-container
              iconBgColor: const Color(0xFF93000A), // error-container
              title: 'Hesabım Kilitlendi'.tr(),
              description: 'Çok sayıda hatalı giriş denemesi nedeniyle hesabınız güvenlik amacıyla geçici olarak kilitlenmiştir. Güvenlik doğrulamasını geçerek hesabınızı açabilirsiniz.'.tr(),
              actionButton: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountRecoveryScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.border, // surface-container-highest
                  foregroundColor: AppColors.textPrimary, // on-surface
                  side: BorderSide(color: AppColors.border.withOpacity(0.5)), // outline-variant
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Kimlik Doğrulama Adımına Git'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Further Help
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // surface-container
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hâlâ sorun mu yaşıyorsunuz?'.tr(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Destek ekibimiz size yardımcı olmaktan memnuniyet duyar.'.tr(),
                          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF7ADC75), // primary
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Destek Talebi Oluştur'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 20),
                      ],
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

  Widget _buildIssueCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required Widget actionButton,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-low
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant/30
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 16),
                actionButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
