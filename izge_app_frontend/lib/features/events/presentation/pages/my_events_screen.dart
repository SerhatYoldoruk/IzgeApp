import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  bool _isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Etkinlik Katılımlarım',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated, // surface-container-low
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isUpcoming = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isUpcoming ? AppColors.border : Colors.transparent, // surface-container-highest
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Yaklaşan',
                            style: TextStyle(
                              color: _isUpcoming ? AppColors.accent : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isUpcoming = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isUpcoming ? AppColors.border : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Geçmiş',
                            style: TextStyle(
                              color: !_isUpcoming ? AppColors.accent : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Event List
            if (_isUpcoming) ...[
              _buildEventCard(
                title: 'Gönüllü Oryantasyonu',
                date: '30 Haziran, 10:00',
                location: 'Online (Zoom)',
                locationIcon: Icons.videocam,
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB0CQ0YKkBelvgVX2mWxOYdHfdv_fVcRylaC3xInAUfWY4AM6MCpHp5nMaKz8-KzctmM-Ei4Ptbtq2TvevAuzj9FZhsNgd99KJy0BJvj8G2-_Ym0SN0KS-y68o9hH6ZPGI1UxxkVY20QKD5hqHfhVg5jl9vsDJSWpi4qAbb1raNZC5RUJMmPw6kR9aHL7w26mP_Cfz8a5GImjEPuDSNXyoETC9-Bft8N4sn90hMeQ_FwKbolUFmGty8J8hEs5iHbCS61AKx6ixtS3D2',
                isConfirmed: false,
              ),
            ] else ...[
              _buildPastEventCard(
                title: 'Engelsiz Sanat Atölyesi',
                date: '25 Haziran, 14:00',
                location: 'Dernek Merkezi',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDGTs43uEzKfQgQaDQCaRtBQu_Oth0Aus6SBD3WB_IeRinE7kd5inHcu7C37POlGSXRA-wlxEqOdzzFcseR8IVUgkBv4ZKZPoh8V-cRqUVn4b712z65k7Jjps9foZlIzOJwddroLVQiFcaKfoszvnWn8cCFzDPDaot50L45ND8Yppji874rEXsIgCbh8FjQ07ho7D882dVMc8hh3WxOZxVl-Avi8b_1WlICdaRaU5necZ1fhIcKzHoFZZvFHmE1Zf19LO_8fM46yO9R',
                status: 'Katıldı',
              ),
              const SizedBox(height: 16),
              _buildPastEventCard(
                title: 'Erişilebilirlik Zirvesi 2023',
                date: '15 Mayıs, 10:00',
                location: 'İstanbul Kültür Merkezi',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBoCBOPjMbkzEing5qM6DKlzUxW-28zD8K53cSh8_pX3XOBqqSFuFqf91qPL8rJUBStOCgJOU-BJPCYIYowRyg15xL_9W29Fdvr8TPfMLOP9CDGpAl2mJBcejd9FR_SrycHf-R80U8QfB-A7YKyMhRXNA9A_pyHzBA7i7gcGaepCq3CXvZO_V4rd-wYluvWzB1rG1ATJ5jnda_TxHWY559eMQ-caafirhJlupoQ5j5H5oOk42ODKJ_GytC-QLkSMiOLMCJuMAWWdgc6',
                status: 'Katıldı',
              ),
              const SizedBox(height: 16),
              _buildPastEventCard(
                title: 'Engelsiz Basketbol Turnuvası',
                date: '2 Nisan, 14:30',
                location: 'Atatürk Spor Kompleksi',
                locationIcon: Icons.sports_score,
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1jXOtHy9xj4KDHw0FCQUM2f-m0xEWqic8QsRrs0dY94HNlJSW1QqLW89y-0Z38FpTIAxpDOMGNQIi9D8rFsYwbmUbiiF3iH-zQwrjjZJ3vyjgzBbwmP9Q_rBeg0AyxrAn8f1G3IOPfEHwqBBJK0rDZBjy7Te5A3rMbb5zsKjrDrUMc9ACnFfRuTzQiE9lQm_0q6W4wlRNw6fGx_dTOxf1O6_DCNICJBEMGv_5lSgEx2Zgq9UBCZuwkHPA305NfJCzNWYSt_ST_Rks',
                status: 'Tamamlandı',
              ),
              const SizedBox(height: 16),
              _buildPastEventCard(
                title: 'Dijital Okuryazarlık Atölyesi',
                date: '12 Mart, 19:00',
                location: 'Online (Zoom)',
                locationIcon: Icons.laptop_mac,
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA5gjjK3hv68CWx42xKMB8Erx0P8soNOPcLd9jTXALxCo_lMMNfJJle967DPuz-3LZR5RGLQAJTwpfx2pVR83m3iSmrE2fxoq5HoI7NZkUV4Mbd1akLnOnQJsMO77jDaiIHTgR8DSQl126ma2D6OmVtoQHihGw4c1CfnXGR3KuMQU3M6J7jBQkr1EbNdGFncnWUGWkDAKlTw6T9A82ajahq98-Q4rQnKwbKFLa2fjffA_XFI9sCXt25wE0jk9Tio_bogTSuUGT6an7g',
                status: 'Katıldı',
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required String imageUrl,
    required bool isConfirmed,
    IconData locationIcon = Icons.location_on,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 128,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 128,
                    color: AppColors.surfaceElevated,
                    child: Icon(Icons.image, color: AppColors.textSecondary, size: 48),
                  ),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Tag
              Positioned(
                bottom: 12,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A8025), // primary-container
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'YAKLAŞAN',
                    style: TextStyle(
                      color: Color(0xFFD3FFC8), // on-primary-container
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 20, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text(date, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(locationIcon, size: 20, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text(location, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 12),
                Divider(color: AppColors.border), // outline-variant/30
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isConfirmed ? Icons.check_circle : Icons.pending,
                          size: 20,
                          color: isConfirmed ? AppColors.accent : AppColors.textSecondary, // secondary-fixed-dim
                        ),
                        SizedBox(width: 8),
                        Text(
                          isConfirmed ? 'Katılım Onaylandı' : 'Onay Bekleniyor',
                          style: TextStyle(
                            color: isConfirmed ? AppColors.accent : AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (isConfirmed)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration( color: AppColors.border, // surface-container-highest
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.qr_code, color: AppColors.textPrimary, size: 20),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastEventCard({
    required String title,
    required String date,
    required String location,
    required String imageUrl,
    required String status,
    IconData locationIcon = Icons.location_on,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                color: AppColors.surfaceElevated,
                child: Icon(Icons.image, color: AppColors.textSecondary, size: 48),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2), // primary-fixed-dim/20
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: AppColors.accent, size: 16),
                          SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 18, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text(date, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(locationIcon, size: 18, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text(location, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
