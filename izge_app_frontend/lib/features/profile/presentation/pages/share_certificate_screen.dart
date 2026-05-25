import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class ShareCertificateScreen extends StatefulWidget {
  const ShareCertificateScreen({super.key});

  @override
  State<ShareCertificateScreen> createState() => _ShareCertificateScreenState();
}

class _ShareCertificateScreenState extends State<ShareCertificateScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7ADC75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sertifikayı Paylaş',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface, // surface-container
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant/30
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Certificate Pattern Background (simulate dots)
                        CustomPaint(
                          size: Size.infinite,
                          painter: _PatternPainter(),
                        ),
                        // Inner Border
                        Positioned(
                          top: 8,
                          left: 8,
                          right: 8,
                          bottom: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF7ADC75).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        // Corner Accents
                        Positioned(top: 0, left: 0, child: _buildCornerAccent(isTop: true, isLeft: true)),
                        Positioned(top: 0, right: 0, child: _buildCornerAccent(isTop: true, isLeft: false)),
                        Positioned(bottom: 0, left: 0, child: _buildCornerAccent(isTop: false, isLeft: true)),
                        Positioned(bottom: 0, right: 0, child: _buildCornerAccent(isTop: false, isLeft: false)),
                        
                        // Big Watermark Icon
                        Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              size: 200,
                              color: const Color(0xFF7ADC75).withOpacity(0.05),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo
                              Container(
                                width: 96,
                                height: 96,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 10),
                                  ],
                                ),
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDNR8vaqVe_5MYGVL5H7EeV7XWvFlF1aJEEl_C4zx-SCGkDpSv92TagLVI5nzxInkZ8iFmZ_FtElqguIwrOR7yi9IrUeklwXQQu89qmNZ4swLuDNnfQMlcDHFjr7GK8wB8VtMbPBgTjQofq_wX0Tc3w9UT-ELzOFPuuhfpWhn1RML9mvjGrNLT2TKZQPuToKOoznfjcFWslwoUlfqk0QDb_SC1t26QQqj1nul7hPJdlpUBywVTr36ukjDLMhbir7pi90PJV6Czpgz0z',
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                              SizedBox(height: 24),
                              
                              const Text(
                                'Bağış Sertifikası',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7ADC75), // primary
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Body Text
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: -10,
                                      left: -10,
                                      child: Icon(Icons.format_quote, size: 64, color: const Color(0xFF7ADC75).withOpacity(0.1)),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 18,
                                          height: 1.6,
                                          color: AppColors.textSecondary, // on-surface-variant
                                        ),
                                        children: [
                                          TextSpan(text: 'Sayın '),
                                          TextSpan(text: 'Ahmet Yılmaz', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                          TextSpan(text: ',\nİzge Derneği\'ne yapmış olduğunuz değerli bağışlarınızla engelleri birlikte aşıyoruz. Desteğiniz için teşekkür ederiz.'),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -10,
                                      right: -10,
                                      child: Transform.rotate(
                                        angle: 3.14159,
                                        child: Icon(Icons.format_quote, size: 64, color: const Color(0xFF7ADC75).withOpacity(0.1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Signature
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  children: [
                                    const Text(
                                      'M. Demir',
                                      style: TextStyle(
                                        fontFamily: 'cursive', // fallback for Brush Script MT
                                        fontSize: 28,
                                        color: Color(0xFF7ADC75),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 1,
                                      color: AppColors.border, // outline-variant
                                      margin: const EdgeInsets.only(bottom: 4),
                                    ),
                                    Text(
                                      'Dernek Başkanı',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textSecondary,
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
                  ),
                ),
              ),
              SizedBox(height: 32),
              
              // Actions Section
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.download, color: AppColors.textPrimary),
                      label: Text(
                        'Sertifikayı İndir',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF899484)), // outline
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Hemen Paylaş',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Horizontal Share Scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildShareOption(
                          icon: Icons.camera_alt,
                          label: 'Hikaye',
                          gradient: const LinearGradient(colors: [Color(0xFFf09433), Color(0xFFe6683c), Color(0xFFbc1888)]),
                        ),
                        const SizedBox(width: 16),
                        _buildShareOption(
                          icon: Icons.chat,
                          label: 'WhatsApp',
                          color: const Color(0xFF25D366),
                        ),
                        const SizedBox(width: 16),
                        _buildShareOption(
                          icon: Icons.close, // Used as 'X' placeholder since there's no native X icon in standard Material Icons
                          label: 'X',
                          color: Colors.black,
                          border: Border.all(color: AppColors.border),
                        ),
                        SizedBox(width: 16),
                        _buildShareOption(
                          icon: Icons.link,
                          label: 'Kopyala',
                          color: AppColors.surfaceElevated, // surface-container-high
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A8025), // primary-container
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const Text(
                        'Tamam',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD3FFC8), // on-primary-container
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerAccent({required bool isTop, required bool isLeft}) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFF7ADC75), width: 2) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFF7ADC75), width: 2) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFF7ADC75), width: 2) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF7ADC75), width: 2) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(16) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(16) : Radius.zero,
          bottomRight: !isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    Color? color,
    Gradient? gradient,
    Border? border,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            gradient: gradient,
            border: border,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7ADC75).withOpacity(0.05)
      ..style = PaintingStyle.fill;
      
    const double spacing = 24.0;
    const double radius = 1.0;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
