import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  String? _selectedType;

  void _showFilePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Dosya Kaynağı Seçin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.camera_alt, color: AppColors.accent),
                ),
                title: Text('Kamera', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.photo_library, color: AppColors.accent),
                ),
                title: Text('Galeri', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.insert_drive_file, color: AppColors.accent),
                ),
                title: Text('Dosyalar', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/images/logo.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'İzge App',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yeni Talep Oluştur',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'İhtiyacınızı bize bildirin, size en kısa sürede yardımcı olalım.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 32),

            // Dropdown
            Text(
              'Talep Türü',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.fieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              dropdownColor: AppColors.surfaceElevated,
              value: _selectedType,
              hint: Text(
                'Lütfen bir tür seçin',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              icon: Icon(Icons.expand_more, color: AppColors.textSecondary),
              items: [
                DropdownMenuItem(value: 'tekerlekli-sandalye', child: Text('Tekerlekli Sandalye Bakımı', style: TextStyle(color: AppColors.textPrimary))),
                DropdownMenuItem(value: 'ilac-yardimi', child: Text('İlaç Yardımı', style: TextStyle(color: AppColors.textPrimary))),
                DropdownMenuItem(value: 'egitim-destegi', child: Text('Eğitim Desteği', style: TextStyle(color: AppColors.textPrimary))),
                DropdownMenuItem(value: 'psikolojik-destek', child: Text('Psikolojik Destek', style: TextStyle(color: AppColors.textPrimary))),
                DropdownMenuItem(value: 'diger', child: Text('Diğer', style: TextStyle(color: AppColors.textPrimary))),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedType = val;
                });
              },
            ),
            SizedBox(height: 24),

            // Text Area
            Text(
              'Talep Detayı',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              maxLines: 5,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.fieldBackground,
                hintText: 'Talebinizi buraya detaylı bir şekilde yazınız...',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 24),

            // Add File Button
            Text(
              'Ek Dosya (İsteğe Bağlı)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showFilePickerBottomSheet(context),
              icon: Icon(Icons.upload_file, color: AppColors.accent),
              label: Text(
                'Dosya Ekle',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.surfaceElevated,
                side: BorderSide(color: AppColors.border, style: BorderStyle.solid),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface, // surface-container
            border: Border(
              top: BorderSide(color: AppColors.border), // surface-variant
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Talebiniz başarıyla gönderildi.')),
                );
              },
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              label: const Text(
                'Talep Gönder',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A8025),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: const Color(0xFF1A8025).withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
