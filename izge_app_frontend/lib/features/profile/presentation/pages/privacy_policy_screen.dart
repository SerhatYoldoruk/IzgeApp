import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gizlilik Politikası'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
             Text(
              'Son Güncelleme: 24 Ekim 2023'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'İzge App olarak gizliliğinize önem veriyoruz. Bu Gizlilik Politikası, uygulamamızı ("İzge App") kullandığınızda kişisel verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklamaktadır. Hizmetlerimizi kullanarak, bu politikada belirtilen uygulamaları kabul etmiş olursunuz.'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),

            // Section 1: Veri Toplama
            _buildSection(
              icon: Icons.storage,
              title: '1. Veri Toplama'.tr(),
              content: [
                Text(
                  'Size daha iyi bir deneyim sunabilmek için çeşitli bilgiler topluyoruz. Bunlar şunları içerebilir:'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                _buildBulletPoint('Kişisel Bilgiler: '.tr(), 'Hesap oluştururken sağladığınız ad, e-posta adresi, telefon numarası gibi bilgiler.'.tr()),
                const SizedBox(height: 8),
                _buildBulletPoint('Kullanım Verileri: '.tr(), 'Uygulama içindeki etkileşimleriniz, ziyaret ettiğiniz sayfalar ve tercihlerinize dair anonim veya kişiselleştirilmiş istatistikler.'.tr()),
                const SizedBox(height: 8),
                _buildBulletPoint('Cihaz Bilgileri: '.tr(), 'Kullandığınız cihazın modeli, işletim sistemi sürümü ve benzersiz cihaz tanımlayıcıları.'.tr()),
              ],
            ),
            const SizedBox(height: 16),

            // Section 2: Veri Kullanımı
            _buildSection(
              icon: Icons.insights,
              title: '2. Veri Kullanımı'.tr(),
              content: [
                Text(
                  'Toplanan veriler, İzge App deneyiminizi iyileştirmek temel amacıyla aşağıdaki şekillerde kullanılır:'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                _buildBulletPoint('', 'Hizmetlerimizi sağlamak, sürdürmek ve iyileştirmek.'.tr()),
                const SizedBox(height: 8),
                _buildBulletPoint('', 'Talep ve anketlerinizi işleme koymak, size özel bildirimler göndermek.'.tr()),
                const SizedBox(height: 8),
                _buildBulletPoint('', 'Kullanıcı güvenliğini sağlamak ve olası dolandırıcılık veya kötüye kullanımı önlemek.'.tr()),
                const SizedBox(height: 8),
                _buildBulletPoint('', 'Yasal yükümlülüklerimizi yerine getirmek.'.tr()),
              ],
            ),
            const SizedBox(height: 16),

            // Section 3: Çerezler ve İzleme
            _buildSection(
              icon: Icons.cookie,
              title: '3. Çerezler ve İzleme'.tr(),
              content: [
                Text(
                  'Uygulamamız, oturum yönetimi ve performans analizi için çeşitli teknik izleme yöntemleri kullanmaktadır. Bu veriler üçüncü taraf reklam ağlarıyla doğrudan paylaşılmaz. Cihaz ayarlarınızdan veri takibini sınırlandırma hakkına sahipsiniz.'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Section 4: İletişim
            _buildSection(
              icon: Icons.mail_outline,
              title: '4. İletişim'.tr(),
              content: [
                Text(
                  'Bu Gizlilik Politikası veya verilerinizin işlenmesiyle ilgili sorularınız, endişeleriniz veya talepleriniz varsa, lütfen bizimle iletişime geçmekten çekinmeyin:'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                _buildContactLink(Icons.alternate_email, 'gizlilik@izgeapp.org'),
                const SizedBox(height: 8),
                _buildContactLink(Icons.help_center_outlined, 'Destek Merkezi'.tr()),
              ],
            ),

            const SizedBox(height: 48),
            
            // Footer
            Center(
              child: Text(
                'İZGE APP © 2023',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated, // surface-container-low
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border), // surface-variant
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated, // surface-container-high
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF1A8025)), // primary-container
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...content,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String boldText, String normalText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6, right: 8),
          child: Icon(Icons.circle, size: 8, color: AppColors.textSecondary),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                if (boldText.isNotEmpty)
                  TextSpan(
                    text: boldText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                TextSpan(text: normalText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactLink(IconData icon, String text) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1A8025), size: 20),
            const SizedBox(width: 8),
            Text(
              text.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A8025),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
