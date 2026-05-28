import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphic (buzlu cam) efektine sahip, ekranın tamamını kaplayan
/// premium yükleniyor (loading) katmanı.
/// Koyu yeşil gradient arka plan kullanarak her iki temada da tutarlı görünür.
class LoadingOverlay extends StatelessWidget {
  /// Yükleniyor durumu aktif mi?
  final bool isLoading;

  /// Yükleme esnasında gösterilecek isteğe bağlı mesaj (Örn: "Giriş yapılıyor...")
  final String? message;

  /// Altındaki ana arayüz bileşeni (Scaffold vb.)
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ana içerik her zaman altta çizilir
        child,

        // Eğer yükleniyor durumundaysak üstüne cam efektli katmanı yerleştir
        if (isLoading)
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, opacity, childWidget) {
                return Opacity(
                  opacity: opacity,
                  child: childWidget,
                );
              },
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                  child: Container(
                    // Koyu yarı saydam arka plan — temadan bağımsız
                    color: const Color(0xFF0A1F0C).withOpacity(0.78),
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.85, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, childWidget) {
                          return Transform.scale(
                            scale: scale,
                            child: childWidget,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 40,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            // Koyu yeşil gradient arka plan — her temada tutarlı
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF162D18), // Koyu yeşil
                                Color(0xFF1A2E1C), // Koyu orman yeşili
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(0xFF7ADC75).withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                              BoxShadow(
                                color: const Color(0xFF7ADC75).withOpacity(0.08),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animasyonlu logo ve yükleme göstergesi
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Yeşil glow efekti
                                  Container(
                                    width: 92,
                                    height: 92,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7ADC75).withOpacity(0.15),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Dönen yükleme göstergesi
                                  const SizedBox(
                                    height: 84,
                                    width: 84,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF7ADC75), // Yeşil renk — sarı değil!
                                      strokeWidth: 2.5,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  // Logo
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        'assets/images/images/logo.jpeg',
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1A3A1D),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: const Icon(
                                              Icons.eco,
                                              color: Color(0xFF7ADC75),
                                              size: 28,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Mesaj metni
                              if (message != null) ...[
                                const SizedBox(height: 28),
                                Text(
                                  message!,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lütfen bekleyin...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF8CC98A), // Açık yeşilimsi — okunabilir
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
