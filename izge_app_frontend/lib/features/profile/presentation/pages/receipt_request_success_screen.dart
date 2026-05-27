import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class ReceiptRequestSuccessScreen extends StatefulWidget {
  final String date;
  final String amount;
  final String transactionNo;

  const ReceiptRequestSuccessScreen({
    super.key,
    required this.date,
    required this.amount,
    required this.transactionNo,
  });

  @override
  State<ReceiptRequestSuccessScreen> createState() => _ReceiptRequestSuccessScreenState();
}

class _ReceiptRequestSuccessScreenState extends State<ReceiptRequestSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
          // Background Image with opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.15, // Subtle background effect
              child: Image.network(
                'https://lh3.googleusercontent.com/aida/ADBb0uhKTcENfP-eQ1gyrv2UIOZwBLPc8S6KnjA3qiXwI9UR6UET4_XDX3yVCp-avj1qaeF9cd_pMRaKXd1oCEKOiwaja2YG7y391_cCfBeRrO4yaMSqrL1YYW_M0T1hzc-CdBUVlZ7bU-I7RNwVyynj_jjzQG_3bCOwL1tz6oRht8ycUZR6dQ0L7cntziUw7Z_M81uV14b904zCt_gQds_WRVBO-n5tsVtnTLA9u9KvyXi-WkEYf_8LnMZJDyhg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'İşlem Başarılı', // Changed from Teknik Destek to fit context better
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.contact_support, color: AppColors.textSecondary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 32),
                        // Success Icon with simple pulse animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container/20
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF7ADC75).withOpacity(0.3)), // primary/30
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1A8025).withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1A8025), // primary-container
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_circle, color: Color(0xFFD3FFC8), size: 40), // on-primary-container
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Typography
                        Text(
                          'Makbuz Talebiniz Alındı',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bağış makbuzunuz hazırlandığında sistemimizde kayıtlı olan e-posta adresinize 24 saat içerisinde PDF formatında gönderilecektir.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 48),
                        
                        // Info Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated, // surface-container-low
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('Tarih', widget.date),
                              Divider(color: AppColors.border), // surface-container-highest
                              _buildInfoRow('Tutar', widget.amount),
                              Divider(color: AppColors.border),
                              _buildInfoRow('İşlem No', widget.transactionNo, isMono: true),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 64),
                        
                        // Primary Action
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.receipt_long, color: Color(0xFFD3FFC8)), // on-primary-container
                            label: const Text(
                              'Makbuzlara Dön',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD3FFC8), // on-primary-container
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A8025), // primary-container
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow(String label, String value, {bool isMono = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: isMono ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}
