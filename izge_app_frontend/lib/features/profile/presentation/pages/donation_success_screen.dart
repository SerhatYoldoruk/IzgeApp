import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/share_certificate_screen.dart';

class DonationSuccessScreen extends StatefulWidget {
  const DonationSuccessScreen({super.key});

  @override
  State<DonationSuccessScreen> createState() => _DonationSuccessScreenState();
}

class _DonationSuccessScreenState extends State<DonationSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Background Layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida/ADBb0uhKTcENfP-eQ1gyrv2UIOZwBLPc8S6KnjA3qiXwI9UR6UET4_XDX3yVCp-avj1qaeF9cd_pMRaKXd1oCEKOiwaja2YG7y391_cCfBeRrO4yaMSqrL1YYW_M0T1hzc-CdBUVlZ7bU-I7RNwVyynj_jjzQG_3bCOwL1tz6oRht8ycUZR6dQ0L7cntziUw7Z_M81uV14b904zCt_gQds_WRVBO-n5tsVtnTLA9u9KvyXi-WkEYf_8LnMZJDyhg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // Success Animation / Icon
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container/20
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A8025).withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A8025), // primary-container
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7ADC75).withOpacity(0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.volunteer_activism,
                            color: Color(0xFFD3FFC8), // on-primary-container
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  
                  // Typography
                  Text(
                    'Teşekkür Ederiz!'.tr(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7ADC75), // primary
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bağışınız başarıyla ulaştırıldı. Desteğinizle daha güçlüyüz.'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary, // on-surface-variant
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 32),
                  
                  // Details Card (Glassmorphism)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.7), // surface-container with opacity
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF899484).withOpacity(0.1)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 32,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bağış Tutarı'.tr(),
                              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                            ),
                            const Text(
                              '₺100',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF96F98E), // primary-fixed
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: AppColors.border, height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kategori'.tr(),
                              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                            ),
                            Text(
                              'Genel Bağış'.tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tarih'.tr(),
                              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                            ),
                            Text(
                              '12 Ekim 2023'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ShareCertificateScreen()),
                        );
                      },
                      icon: Icon(Icons.share, color: AppColors.textPrimary, size: 20),
                      label: Text(
                        'Sertifikayı Paylaş'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surfaceElevated, // surface-container-high
                        side: BorderSide(color: AppColors.border.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate back to Home
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home, color: Color(0xFF003908), size: 20),
                      label: Text(
                        'Ana Sayfaya Dön'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003908),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A8025), // primary-container
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF1A8025).withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
