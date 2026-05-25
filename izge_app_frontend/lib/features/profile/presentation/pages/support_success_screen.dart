import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';

class SupportSuccessScreen extends StatefulWidget {
  const SupportSuccessScreen({super.key});

  @override
  State<SupportSuccessScreen> createState() => _SupportSuccessScreenState();
}

class _SupportSuccessScreenState extends State<SupportSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.1).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)));

    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.7, curve: Curves.easeOut)),
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.9, curve: Curves.easeOut)),
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
          // Ambient Background Glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF1A8025).withOpacity(0.15), // primary-container
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF1A8025).withOpacity(0.15), blurRadius: 120, spreadRadius: 60),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon Container
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                color: AppColors.border, // surface-container-highest
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(color: Colors.black45, blurRadius: 24, offset: Offset(0, 4)),
                                ],
                              ),
                              child: Icon(Icons.check_circle, color: Color(0xFF7ADC75), size: 80), // primary
                            ),
                          ),
                          SizedBox(height: 32),
                          
                          // Typography
                          FadeTransition(
                            opacity: _fadeAnimation1,
                            child: Text(
                              'Talebiniz Alındı',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8),
                          FadeTransition(
                            opacity: _fadeAnimation2,
                            child: Text(
                              'Destek ekibimiz en kısa sürede size dönüş yapacaktır.',
                              style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 32),
                          
                          // Process Tracker
                          FadeTransition(
                            opacity: _fadeAnimation2,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withOpacity(0.8), // surface-container
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border), // surface-variant
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 10),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Süreç Takibi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  SizedBox(height: 24),
                                  
                                  Stack(
                                    children: [
                                      // Background Line
                                      Positioned(
                                        top: 11,
                                        left: 16,
                                        right: 16,
                                        child: Container(height: 2, color: AppColors.border), // surface-variant
                                      ),
                                      // Active Line
                                      Positioned(
                                        top: 11,
                                        left: 16,
                                        width: MediaQuery.of(context).size.width * 0.35, // Approx 50%
                                        child: Container(height: 2, color: const Color(0xFF1A8025)), // primary-container
                                      ),
                                      
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Step 1
                                          _buildStep(
                                            active: true,
                                            completed: true,
                                            label: 'Alındı',
                                            labelColor: const Color(0xFF7ADC75), // primary
                                          ),
                                          // Step 2
                                          _buildStep(
                                            active: true,
                                            completed: false,
                                            label: 'İşleniyor',
                                            labelColor: AppColors.textPrimary,
                                          ),
                                          // Step 3
                                          _buildStep(
                                            active: false,
                                            completed: false,
                                            label: 'Tamamlandı',
                                            labelColor: AppColors.textSecondary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Bottom Action
                FadeTransition(
                  opacity: _fadeAnimation2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate back to Help Center
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                            (Route<dynamic> route) => route.isFirst,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, color: Color(0xFF003908)),
                        label: const Text('Ana Sayfaya Dön', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003908))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7ADC75), // primary
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required bool active, required bool completed, required String label, required Color labelColor}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: completed ? const Color(0xFF1A8025) : (active ? AppColors.surface : AppColors.surface),
            shape: BoxShape.circle,
            border: Border.all(
              color: completed ? const Color(0xFF1A8025) : (active ? const Color(0xFF1A8025) : AppColors.border),
              width: 2,
            ),
          ),
          child: completed
              ? const Icon(Icons.check, color: Color(0xFFD3FFC8), size: 14)
              : (active ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF1A8025), shape: BoxShape.circle))) : null),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.normal, color: labelColor),
        ),
      ],
    );
  }
}
