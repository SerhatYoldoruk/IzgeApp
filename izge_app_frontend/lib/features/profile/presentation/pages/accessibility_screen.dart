import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/accessibility/accessibility_controller.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  @override
  void initState() {
    super.initState();
    AccessibilityController.instance.addListener(_onAccessibilityChanged);
  }

  @override
  void dispose() {
    AccessibilityController.instance.removeListener(_onAccessibilityChanged);
    super.dispose();
  }

  void _onAccessibilityChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = AccessibilityController.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Erişilebilirlik'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.text_fields, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Text(
                      'Metin Boyutu'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Uygulama genelindeki metinlerin büyüklüğünü ayarlayabilirsiniz.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('A', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                    Expanded(
                      child: Slider(
                        value: controller.textScaleFactor,
                        min: 0.8,
                        max: 1.5,
                        divisions: 7,
                        activeColor: AppColors.accent,
                        inactiveColor: AppColors.border,
                        label: '${(controller.textScaleFactor * 100).toInt()}%',
                        onChanged: (value) {
                          controller.updateTextScaleFactor(value);
                        },
                      ),
                    ),
                    Text('A', style: TextStyle(fontSize: 24, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.zoom_in),
                    label: const Text('Maksimum Büyüklük'),
                    onPressed: () {
                      controller.setMaxTextScale();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.contrast, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Yüksek Kontrast'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: controller.isHighContrastEnabled,
                      activeColor: AppColors.accent,
                      onChanged: (val) {
                        controller.toggleHighContrast();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Görme güçlüğü olan bireyler için renkleri siyah, sarı ve beyaz ağırlıklı, çok belirgin bir şemaya geçirir.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.spellcheck, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Disleksi Dostu Font'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: controller.isDyslexiaFontEnabled,
                      activeColor: AppColors.accent,
                      onChanged: (val) {
                        controller.toggleDyslexiaFont();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Okumayı kolaylaştırmak için harf boşlukları artırılmış ve harf şekilleri belirginleştirilmiş (Lexend) font kullanır.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Önizleme Alanı
          Text(
            'Önizleme'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Örnek Başlık',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bu metin, seçmiş olduğunuz font (yazı tipi) ve metin boyutuna göre nasıl görüneceğini test etmeniz için buraya eklenmiştir. Değişiklikler anında tüm uygulamaya yansır.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
