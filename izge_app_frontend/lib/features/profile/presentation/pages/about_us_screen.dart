import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/widgets/social_links_row.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/contact_support_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
        title: const Text(
          'İzge App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Hero Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/images/logo.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'İzge Derneği',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ancak Birlikte Başarabiliriz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Our Story
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A8025), // primary-container
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_edu,
                          color: Color(0xFFD3FFC8),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Hikayemiz',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'İzge Derneği, toplumsal dayanışmayı güçlendirmek ve dezavantajlı gruplara sürdürülebilir destek sağlamak amacıyla kuruldu. Bir avuç gönüllünün çabasıyla başlayan bu yolculuk, bugün binlerce hayata dokunan büyük bir aileye dönüştü. Amacımız, yardımlaşmayı şeffaf ve ulaşılabilir kılarak daha adil bir yarın inşa etmektir.',
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

            SizedBox(height: 16),

            // Vision & Mission
            Column(
              children: [
                _buildVisionMissionCard(
                  icon: Icons.visibility,
                  title: 'Vizyonumuz',
                  content:
                      'Dernek çalışma konuları ve biçimleri ile faaliyet alanları çerçevesinde üyelerine eğitim başta olmak üzere kültürel, sosyal ve sportif alanlarda destek vermek. Üyelerinin tümünü temsil edebilen, haklarını koruyabilen, gelişmeler karşısında öncü, kapsayıcı toplum uygulamalarında hak temelli çalışan, gündem belirleyici ve söz sahibi olabilen örnek bir sivil toplum kuruluşu olmak.',
                  borderColor: const Color(0xFF7ADC75), // primary
                  iconColor: const Color(0xFF7ADC75),
                ),
                const SizedBox(height: 16),
                _buildVisionMissionCard(
                  icon: Icons.flag,
                  title: 'Misyonumuz',
                  content:
                      'Nöroçeşitliliğe sahip bireylerin toplumla bütünleşmesi, hayata katılmaları, iş ve meslek sahibi olmalarına katkıda bulunmak. Derneğimizi kurumlaşmasını sağlamak. Çalışmalarında demokratik, şeffaf ve sürdürülebilir, toplum ile uyum içinde bütünleşik hizmeti sağlamaktır.',
                  borderColor: AppColors.textSecondary,
                  iconColor: AppColors.textSecondary,
                ),
              ],
            ),

            SizedBox(height: 32),

            // Our Values
            Text(
              'Değerlerimiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildValueCard(Icons.diversity_1, 'Eşitlik')),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildValueCard(
                    Icons.accessibility_new,
                    'Erişilebilirlik',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildValueCard(Icons.handshake, 'Dayanışma')),
                const SizedBox(width: 16),
                Expanded(child: _buildValueCard(Icons.verified, 'Şeffaflık')),
              ],
            ),

            const SizedBox(height: 32),

            // Contact Info
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Bizimle İletişime Geçin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(Icons.mail, 'izgedernegi@gmail.com'),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    Icons.call,
                    '+90 506 323 23 31\n+90 536 527 80 74',
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    Icons.location_on,
                    'Günaydın Mah. Terziler Cad. No:41/30 Bandırma',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactSupportScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.send, color: AppColors.background),
                      label: Text(
                        'Bize Yazın',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Bizi Takip Edin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SocialLinksRow(),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildVisionMissionCard({
    required IconData icon,
    required String title,
    required String content,
    required Color borderColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
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
              Icon(icon, color: iconColor, size: 24),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, // dynamically adapt to theme
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF7ADC75), size: 32),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
