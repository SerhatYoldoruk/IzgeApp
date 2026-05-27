import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class ChangePhotoScreen extends StatefulWidget {
  const ChangePhotoScreen({super.key});

  @override
  State<ChangePhotoScreen> createState() => _ChangePhotoScreenState();
}

class _ChangePhotoScreenState extends State<ChangePhotoScreen> {
  bool _isLoading = false;

  void _handleSave() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Profil fotoğrafı güncellendi!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF1A8025), // primary-container
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
        elevation: 8,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Fotoğrafı Değiştir',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Avatar Preview
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated, // surface-container-high
                        border: Border.all(color: AppColors.surfaceElevated, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuA7OE-jBow4RlfZ0YX-99sjlZa-dVOd2sK3krkn8m-YxVJYqBtoZoME2ovtvvN0U91Y4I5FmaWCZFls6AwpakmpvpuXLpJwN-RDxVcEL6IIAT61aYh0GLsx-O2d6ElqA9PV_jVORW8DC-WDJPf8u-SJpLCFktk54wojVQnUtGEun1vmKJg60PDj_JZ4VwlF53xsqgKu1Zah5OpzTjeyKDpEN93a4XxiakfSzwuKhcTGJi9ENAKfuDNJXRlv6Ejfo7wPozQxmgGZzxqo',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                splashColor: Colors.black.withOpacity(0.3),
                                highlightColor: Colors.black.withOpacity(0.1),
                                child: Container(
                                  color: Colors.black.withOpacity(0.2), // Subtle overlay
                                  child: const Center(
                                    child: Icon(Icons.edit, color: Colors.white, size: 36),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Profil fotoğrafınız toplulukta nasıl göründüğünüzü belirler.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ),

              // Action Options Bento Grid style
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildOptionCard(
                      icon: Icons.photo_camera,
                      title: 'Fotoğraf Çek',
                      subtitle: 'Kameranızı kullanarak yeni bir fotoğraf çekin',
                      iconBgColor: const Color(0xFF1A8025), // primary-container
                      iconColor: const Color(0xFFD3FFC8), // on-primary-container
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      icon: Icons.image,
                      title: 'Galeriden Seç',
                      subtitle: 'Cihazınızdaki fotoğraflar arasından seçim yapın',
                      iconBgColor: AppColors.border, // surface-variant
                      iconColor: AppColors.textPrimary,
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    _buildOptionCard(
                      icon: Icons.delete,
                      title: 'Mevcut Fotoğrafı Kaldır',
                      subtitle: null,
                      iconBgColor: const Color(0xFF93000A).withOpacity(0.3), // error-container/30
                      iconColor: const Color(0xFFFFB4AB), // error
                      titleColor: const Color(0xFFFFB4AB), // error
                      onTap: () {},
                      showChevron: false,
                    ),
                  ],
                ),
              ),

              // Sticky Bottom Action
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleSave,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Color(0xFFD3FFC8),
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle, color: Color(0xFFD3FFC8)),
                  label: Text(
                    _isLoading ? 'Kaydediliyor...' : 'Kaydet',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color(0xFFD3FFC8),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A8025), // primary-container
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconBgColor,
    required Color iconColor,
    Color? titleColor,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    final effectiveTitleColor = titleColor ?? AppColors.textPrimary;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // surface-container
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: effectiveTitleColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showChevron)
                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
