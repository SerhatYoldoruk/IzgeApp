import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hesap Bağla',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            Text(
              'Sosyal medya hesaplarınızı bağlayarak profilinizi zenginleştirin ve toplulukla daha kolay etkileşime geçin.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Social Media Accounts List
            _buildLinkedAccount(
              icon: Icons.close,
              title: 'X (Twitter)',
              subtitle: '@izge_official',
              isLinked: true,
              subtitleColor: AppColors.accent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağlantı kesildi')));
              },
            ),
            const SizedBox(height: 16),
            
            _buildLinkedAccount(
              icon: Icons.facebook,
              title: 'Facebook',
              subtitle: 'Bağlı değil',
              isLinked: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hesap bağlandı')));
              },
            ),
            const SizedBox(height: 16),
            
            _buildLinkedAccount(
              icon: Icons.camera_alt,
              title: 'Instagram',
              subtitle: 'Bağlı değil',
              isLinked: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hesap bağlandı')));
              },
            ),
            
            SizedBox(height: 48),
            
            // Informational Visual / Glassmorphism Illustration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A8025).withOpacity(0.2), // primary-container/20
                    AppColors.border,
                  ],
                ),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Güvenli Bağlantı',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD3FFC8), // on-primary-container
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Verileriniz İzge ekosistemi içinde şifrelenmiş olarak saklanır. Sizin izniniz olmadan asla paylaşım yapılmaz.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.verified_user, color: AppColors.accent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'KVKK UYUMLU',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Footer
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.surfaceElevated,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(text: 'Hesabınızı bağladığınızda '),
                    TextSpan(
                      text: 'Kullanım Koşulları',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(text: ' ve '),
                    TextSpan(
                      text: 'Gizlilik Politikası',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextSpan(text: '\'nı kabul etmiş sayılırsınız.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedAccount({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLinked,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.textPrimary),
              ),
              SizedBox(width: 16),
              Column(
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
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor ?? AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isLinked ? const Color(0xFFFFB4AB) : const Color(0xFF1A8025), // error or primary-container
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isLinked ? 16 : 24,
                vertical: 8,
              ),
            ),
            child: Text(
              isLinked ? 'Bağlantıyı Kes' : 'Bağla',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isLinked ? const Color(0xFFFFB4AB) : const Color(0xFF1A8025),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
