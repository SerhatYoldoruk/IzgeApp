import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'login_screen.dart';
import 'email_verified_screen.dart';

/// Uygulamanın ilk açılış ekranı (Splash Screen).
/// Koyu yeşil gradient arka plan üzerine logo ve animasyonlu parıltı efekti.
/// Hem açık hem koyu temada aynı premium görünümü sunar.
class SplashScreen extends StatefulWidget {
  final Future<void>? initialization;

  const SplashScreen({super.key, this.initialization});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Logo arkasındaki yeşil parlamayı yavaşça büyütüp küçültecek sonsuz döngü
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Alt kısımdaki yükleme noktaları için nabız animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startInitializationFlow();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Uygulama başlatma akışını kontrol eder
  Future<void> _startInitializationFlow() async {
    final startTime = DateTime.now();

    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      precacheImage(const AssetImage('assets/images/images/logo.jpeg'), context);
      precacheImage(const AssetImage('assets/images/images/google_logo.png'), context);
    }

    if (widget.initialization != null) {
      try {
        await widget.initialization;
      } catch (e) {
        debugPrint("Splash initialization hatası: \$e");
      }
    }

    bool isEmailVerification = false;
    try {
      final appLinks = AppLinks();
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null && initialLink.toString().contains('type=signup')) {
        isEmailVerification = true;
      }
    } catch (e) {
      debugPrint("Deep link error: \$e");
    }

    // Minimum 2.5 saniye ekranda kalma garantisi
    final elapsed = DateTime.now().difference(startTime);
    final remainingDelay = const Duration(milliseconds: 2500) - elapsed;
    if (remainingDelay > Duration.zero) {
      await Future.delayed(remainingDelay);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              isEmailVerification ? const EmailVerifiedScreen() : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1F0C), // Çok koyu yeşil
              Color(0xFF122614), // Koyu yeşil
              Color(0xFF0D1B0F), // Derin orman yeşili
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dekoratif halka desenleri (arka plan)
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7ADC75).withOpacity(0.06),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -120,
                left: -60,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7ADC75).withOpacity(0.04),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // Ana içerik - Logo, isim, slogan
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animasyonlu glow efekti + logo
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Dış parlama efekti
                            Container(
                              width: 160 * _glowAnimation.value,
                              height: 160 * _glowAnimation.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7ADC75).withOpacity(0.15),
                                    blurRadius: 50,
                                    spreadRadius: 25 * _glowAnimation.value,
                                  ),
                                ],
                              ),
                            ),
                            // Logo giriş animasyonu (fade-in & scale-up)
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutBack,
                              builder: (context, val, child) {
                                return Transform.scale(
                                  scale: 0.6 + (val * 0.4),
                                  child: Opacity(opacity: (val.toDouble()).clamp(0.0, 1.0), child: child),
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF7ADC75).withOpacity(0.4),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7ADC75).withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/images/logo.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Uygulama Adı
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeOut,
                      builder: (context, val, child) {
                        final safeVal = val.clamp(0.0, 1.0);
                        return Opacity(
                          opacity: safeVal,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - safeVal)),
                            child: child,
                          ),
                        );
                      },
                      child: const Column(
                        children: [
                          Text(
                            'İZGE',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 6.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Sosyal Yardımlaşma Platformu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8CC98A), // Açık yeşilimsi gri - her arka planda okunur
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Alt yükleme göstergesi — minimalist 3 nokta
              Positioned(
                bottom: 56,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1800),
                  builder: (context, val, child) {
                    return Opacity(opacity: val.clamp(0.0, 1.0), child: child);
                  },
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          final delay = index * 0.15;
                          final progress = (_pulseAnimation.value - delay).clamp(0.0, 1.0);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.lerp(
                                const Color(0xFF7ADC75).withOpacity(0.2),
                                const Color(0xFF7ADC75),
                                progress,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
