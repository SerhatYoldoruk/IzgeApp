import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class SocialLinksRow extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;

  const SocialLinksRow({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        _buildSocialIcon(
          icon: Icons.camera_alt_outlined, // Instagram
          color: const Color(0xFFE1306C),
          onTap: () => _launchUrl('https://www.instagram.com/izgedernegi/?hl=tr'),
        ),
        const SizedBox(width: 16),
        _buildSocialIcon(
          icon: Icons.facebook, // Facebook
          color: const Color(0xFF1877F2),
          onTap: () => _launchUrl('https://www.facebook.com/p/%C4%B0zge-Engelli-Derne%C4%9Fi-61559805162069/'),
        ),
        const SizedBox(width: 16),
        _buildSocialIcon(
          icon: Icons.language, // Website
          color: const Color(0xFF7ADC75),
          onTap: () => _launchUrl('https://www.izgeengellidernegi.org.tr/'),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border), // surface-container-highest
            color: AppColors.surfaceElevated, // surface-container-low
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}
