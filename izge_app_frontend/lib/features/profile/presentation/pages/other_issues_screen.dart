import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/support_success_screen.dart';

class OtherIssuesScreen extends StatefulWidget {
  const OtherIssuesScreen({super.key});

  @override
  State<OtherIssuesScreen> createState() => _OtherIssuesScreenState();
}

class _OtherIssuesScreenState extends State<OtherIssuesScreen> {
  String? _selectedTopic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Teknik Destek',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75), // primary
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.contact_support, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diğer Sorunlar',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aradığınız sorunu bulamadıysanız aşağıdaki form ile bize ulaşabilirsiniz. Ekibimiz en kısa sürede size dönüş yapacaktır.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withOpacity(0.9),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            
            // Topic Dropdown
            Text(
              'Konu Başlığı',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.border, // surface-variant
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTopic,
                  hint: Text('Lütfen bir konu seçin...', style: TextStyle(color: AppColors.textSecondary)),
                  isExpanded: true,
                  dropdownColor: AppColors.border,
                  icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  items: const [
                    DropdownMenuItem(value: 'hesap', child: Text('Hesap İşlemleri ve Profil')),
                    DropdownMenuItem(value: 'etkinlik', child: Text('Etkinlik Katılımı / İptali')),
                    DropdownMenuItem(value: 'bagis', child: Text('Bağış ve Ödeme Sorunları')),
                    DropdownMenuItem(value: 'uygulama', child: Text('Uygulama İçi Hata (Bug)')),
                    DropdownMenuItem(value: 'diger', child: Text('Farklı Bir Konu')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTopic = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Details Textarea
            Text(
              'Detaylı Açıklama',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.border, // surface-variant
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                maxLines: 6,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Yaşadığınız sorunu, ne yaparken karşılaştığınızı ve ek detayları buraya yazabilirsiniz...',
                  hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                  suffixIcon: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(16),
                    child: Icon(Icons.edit_note, size: 48, color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Attachment
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated, // surface-container-low
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration( color: AppColors.border,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_photo_alternate, color: Color(0xFF7ADC75)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ekran Görüntüsü Ekle',
                            style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                          ),
                          Text(
                            'İsteğe bağlı, max 5MB',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
              // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SupportSuccessScreen()),
                  );
                },
                icon: const Icon(Icons.send, color: Color(0xFF003908)),
                label: const Text(
                  'Destek Talebi Oluştur',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003908),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ADC75), // primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF7ADC75).withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
