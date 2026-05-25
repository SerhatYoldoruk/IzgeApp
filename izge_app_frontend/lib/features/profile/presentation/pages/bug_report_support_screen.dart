import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/support_success_screen.dart';

class BugReportSupportScreen extends StatelessWidget {
  const BugReportSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)), // primary
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Destek Merkezi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hata Bildirimi',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            SizedBox(height: 8),
            Text(
              'Karşılaştığınız sorunu çözebilmemiz için lütfen detayları bizimle paylaşın.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.6), // glass-card
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF899484).withOpacity(0.1)),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error Type Dropdown
                  Text('Hata Türü', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border, // surface-variant
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Lütfen bir hata türü seçin', style: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surfaceElevated,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
                        icon: Icon(Icons.expand_more, color: AppColors.textSecondary),
                        items: const [
                          DropdownMenuItem(value: 'crash', child: Text('Uygulama Çökmesi')),
                          DropdownMenuItem(value: 'freeze', child: Text('Donma / Takılma')),
                          DropdownMenuItem(value: 'data', child: Text('Yanlış Veri Gösterimi')),
                          DropdownMenuItem(value: 'other', child: Text('Diğer')),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description Textarea
                  Text('Hata Açıklaması', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.border, // surface-variant
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      maxLines: 5,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Hatayı nasıl ve nerede aldığınızı detaylıca açıklayın...',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // File Upload (Optional)
                  Text('Ekran Görüntüsü (Opsiyonel)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border, style: BorderStyle.solid, width: 2), // dashed effect usually needs custom painter in Flutter, solid for now
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.cloud_upload, color: Color(0xFF7ADC75), size: 40),
                        SizedBox(height: 8),
                        Text('Görsel yüklemek için tıklayın veya sürükleyin', style: TextStyle(fontSize: 16, color: AppColors.textSecondary), textAlign: TextAlign.center),
                        SizedBox(height: 4),
                        Text('PNG, JPG (Maks. 5MB)', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)), // secondary-fixed-dim
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

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
                      icon: const Icon(Icons.send, color: Color(0xFF003908)), // on-primary
                      label: const Text('Hata Bildir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003908))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7ADC75), // primary
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        elevation: 4,
                        shadowColor: const Color(0xFF7ADC75).withOpacity(0.25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
