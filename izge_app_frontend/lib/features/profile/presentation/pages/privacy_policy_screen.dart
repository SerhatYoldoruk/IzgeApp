import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';

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
          'KVKK ve Gizlilik Politikası',
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
              'Son Güncelleme: 6 Haziran 2026',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'İzge Derneği (bundan böyle "Veri Sorumlusu" veya "Dernek" olarak anılacaktır) olarak, 6698 Sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") ve ilgili mevzuat uyarınca kişisel verilerinizin güvenliğine ve gizliliğine en yüksek düzeyde önem veriyoruz. Bu metin, İzge mobil uygulaması ("Uygulama") üzerinden toplanan kişisel verilerinizin nasıl işlendiği, saklandığı ve korunduğu hakkında sizi şeffaf bir şekilde bilgilendirmek amacıyla hazırlanmıştır.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),

            // Section 1: Veri Sorumlusu
            _buildSection(
              icon: Icons.person_pin_circle_outlined,
              title: '1. Veri Sorumlusunun Kimliği',
              content: [
                Text(
                  'KVKK kapsamında Veri Sorumlusu, faaliyetlerini İzge Derneği tüzel kişiliği altında yürüten derneğimizdir. Kişisel verileriniz, veri sorumlusu sıfatıyla derneğimiz tarafından aşağıda açıklanan kapsamda işlenebilecektir.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section 2: İşlenen Veriler
            _buildSection(
              icon: Icons.data_usage,
              title: '2. İşlenen Kişisel Verileriniz',
              content: [
                Text(
                  'Uygulamayı kullanımınız kapsamında aşağıdaki verileriniz işlenebilmektedir:',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                _buildBulletPoint(
                  'Kimlik Bilgileri: ',
                  'Ad, soyad, doğum tarihi (gerektiğinde T.C. Kimlik Numarası; yalnızca yasal işlemler ve bağış makbuzları için).',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'İletişim Bilgileri: ',
                  'E-posta adresi, telefon numarası, ikametgah/adres bilgisi.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'İşlem Güvenliği Verileri: ',
                  'IP adresi, uygulama içi erişim logları, hesap şifre bilgileri.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Finansal Bilgiler: ',
                  'Düzenli veya tek seferlik aidat/bağış işlemlerinize ait dekont kayıtları. (ÖNEMLİ: Kredi kartı numaralarınız bizim tarafımızdan SAKLANMAZ; BDDK lisanslı aracı kurumların güvenli altyapılarında şifrelenir).',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section 3: Amaçlar
            _buildSection(
              icon: Icons.track_changes,
              title: '3. İşlenme Amaçları',
              content: [
                Text(
                  'Kişisel verileriniz aşağıdaki amaçlarla işlenmektedir:',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                _buildBulletPoint(
                  '',
                  'Dernek üyelik işlemlerinin, aidat takiplerinin ve bağış süreçlerinin yürütülmesi.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  '',
                  'Kullanıcıların yardım, destek veya etkinlik taleplerinin (Tekerlekli sandalye, eğitim, vb.) kayıt altına alınması ve koordine edilmesi.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  '',
                  'Yasal mevzuatlardan doğan bilgi saklama, raporlama ve dernekler masasına beyan yükümlülüklerinin yerine getirilmesi.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  '',
                  'Dernek faaliyetleri hakkında sizlere iletişim kanalları üzerinden bilgilendirme, haber bülteni veya acil çağrı bildirimlerinin gönderilmesi.',
                ),
              ],
            ),
            SizedBox(height: 16),

            // Section 4: Veri Aktarımı ve Güvenlik
            _buildSection(
              icon: Icons.shield_outlined,
              title: '4. Veri Aktarımı ve Bulut Güvenliği',
              content: [
                Text(
                  'Uygulama altyapımız, verilerinizin güvenliği için uluslararası güvenlik sertifikalarına (ISO 27001, SOC 2) sahip Supabase ve AWS bulut sistemlerinde barındırılmaktadır. Tüm veri tabanı işlemleri endüstri standardı olan güçlü şifreleme algoritmalarıyla (Encryption at Rest/in Transit) korunur.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Kişisel verileriniz, yasal zorunluluklar (yetkili kamu kurum ve kuruluşları) haricinde hiçbir 3. taraf reklam, pazarlama veya ticari şirketle SATILMAZ veya İZİNSİZ PAYLAŞILMAZ.',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(
                      0xFF7ADC75,
                    ), // Primary color to highlight
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Section 5: Haklar
            _buildSection(
              icon: Icons.balance,
              title: '5. İlgili Kişinin Hakları (KVKK Md. 11)',
              content: [
                Text(
                  'KVKK\'nın 11. maddesi uyarınca derneğimize başvurarak;',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                _buildBulletPoint(
                  '',
                  'Kişisel verilerinizin işlenip işlenmediğini öğrenme,',
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  '',
                  'Kişisel verileriniz işlenmişse buna ilişkin bilgi talep etme,',
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  '',
                  'Eksik veya yanlış işlenen verilerin düzeltilmesini isteme,',
                ),
                const SizedBox(height: 4),
                _buildBulletPoint(
                  '',
                  'Kişisel verilerinizin silinmesini (Unutulma Hakkı) veya yok edilmesini talep etme haklarına sahipsiniz.',
                ),
              ],
            ),
            SizedBox(height: 16),

            // Section 6: İletişim
            _buildSection(
              icon: Icons.mail_outline,
              title: '6. İletişim',
              content: [
                Text(
                  'Haklarınızı kullanmak ve kişisel verilerinizle ilgili her türlü talebinizi iletmek için bizimle iletişime geçebilirsiniz:',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                _buildContactLink(Icons.alternate_email, 'kvkk@izgeapp.org'),
                const SizedBox(height: 8),
                _buildContactLink(
                  Icons.help_center_outlined,
                  'Destek Merkezi (Uygulama İçi)',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Footer
            Center(
              child: Text(
                'İZGE DERNEĞİ © 2026',
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
                child: Icon(
                  icon,
                  color: const Color(0xFF1A8025),
                ), // primary-container
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
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
                fontSize: 15,
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

  Widget _buildContactLink(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1A8025), size: 20),
            const SizedBox(width: 8),
            Text(
              text,
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
