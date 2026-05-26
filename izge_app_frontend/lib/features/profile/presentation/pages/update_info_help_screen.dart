import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/personal_info_screen.dart';

class UpdateInfoHelpScreen extends StatelessWidget {
  const UpdateInfoHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF96F98E)), // primary-fixed
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Context Title
                Text(
                  'Bilgilerimi Güncelleme'.tr(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hesap bilgilerinizi güncel tutmak, kurum içi iletişim ve operasyonların sağlıklı yürümesi için önemlidir.'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Instructions Bento Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    if (isWide) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildInstructionCard(
                                  Icons.person,
                                  'Kişisel Profil'.tr(),
                                  'Ad, soyad, telefon ve e-posta bilgilerinizi profil ayarları bölümünden dilediğiniz zaman değiştirebilirsiniz. Değişiklikler anında sisteme yansır.'.tr(),
                                  const Color(0xFF1A8025), // primary-container
                                  const Color(0xFF96F98E), // primary-fixed
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildInstructionCard(
                                  Icons.location_on,
                                  'Adres Bilgileri'.tr(),
                                  'Gönüllülük faaliyetleri ve olası kargo gönderimleri için ikametgah adresinizin doğruluğu elzemdir. Birden fazla adres ekleyebilir, varsayılanı seçebilirsiniz.'.tr(),
                                  AppColors.surfaceElevated, // secondary-container
                                  AppColors.textSecondary, // secondary
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildInstructionCard(
                            Icons.description,
                            'Evrak ve Belgeler'.tr(),
                            'Bağış makbuzları, KVKK onay formları veya kurum kimlik belgelerinizi dijital formatta yükleyerek arşivleyebilirsiniz.'.tr(),
                            AppColors.textSecondary, // tertiary-container
                            AppColors.textSecondary, // tertiary
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildInstructionCard(
                            Icons.person,
                            'Kişisel Profil'.tr(),
                            'Ad, soyad, telefon ve e-posta bilgilerinizi profil ayarları bölümünden dilediğiniz zaman değiştirebilirsiniz. Değişiklikler anında sisteme yansır.'.tr(),
                            const Color(0xFF1A8025), // primary-container
                            const Color(0xFF96F98E), // primary-fixed
                          ),
                          SizedBox(height: 16),
                          _buildInstructionCard(
                            Icons.location_on,
                            'Adres Bilgileri'.tr(),
                            'Gönüllülük faaliyetleri ve olası kargo gönderimleri için ikametgah adresinizin doğruluğu elzemdir. Birden fazla adres ekleyebilir, varsayılanı seçebilirsiniz.'.tr(),
                            AppColors.surfaceElevated, // secondary-container
                            AppColors.textSecondary, // secondary
                          ),
                          SizedBox(height: 16),
                          _buildInstructionCard(
                            Icons.description,
                            'Evrak ve Belgeler'.tr(),
                            'Bağış makbuzları, KVKK onay formları veya kurum kimlik belgelerinizi dijital formatta yükleyerek arşivleyebilirsiniz.'.tr(),
                            AppColors.textSecondary, // tertiary-container
                            AppColors.textSecondary, // tertiary
                          ),
                        ],
                      );
                    }
                  },
                ),
                
                SizedBox(height: 32),
                
                // Warning Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated, // surface-container-high
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: Color(0xFF7ADC75), width: 4), // primary
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Color(0xFF96F98E), size: 24), // primary-fixed
                          SizedBox(width: 12),
                          Text(
                            'Dikkat Edilmesi Gerekenler'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF96F98E), // primary-fixed
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildWarningListItem('Bilgilerinizi güncellerken resmi kimliğinizdeki formatı kullanmaya özen gösterin.'.tr()),
                      const SizedBox(height: 8),
                      _buildWarningListItem('E-posta ve telefon numarası değişikliklerinde doğrulama kodu gönderilecektir.'.tr()),
                      const SizedBox(height: 8),
                      _buildWarningListItem('Hatalı girilen IBAN veya adres bilgileri, süreçlerde gecikmelere yol açabilir.'.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border.withOpacity(0.5)), // surface-variant
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to Profile Info Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF899484)), // outline
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26), // full rounded
                ),
                foregroundColor: AppColors.textPrimary, // text-inverse-surface equivalent
              ),
              child: Text(
                'Profilime Git'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard(IconData icon, String title, String description, Color stripeColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border), // surface-variant
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: stripeColor.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration( color: AppColors.border, // surface-variant
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
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
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningListItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
