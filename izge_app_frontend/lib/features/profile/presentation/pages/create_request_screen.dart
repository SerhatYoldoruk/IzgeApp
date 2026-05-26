import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/request_status_screen.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Tıbbi Cihaz Desteği',
    'Eğitim Bursu',
    'Psikolojik Danışmanlık',
    'Hukuki Yardım',
    'Diğer',
  ];

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isSubmitting = false);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Talebiniz başarıyla oluşturuldu! (TLP-10492)'.tr()),
              backgroundColor: const Color(0xFF1A8025), // primary-container
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          
          // Go to status screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RequestStatusScreen()),
          );
        }
      });
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen bir talep kategorisi seçiniz.'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Yeni Talep Oluştur'.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7ADC75),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Talep Detayları'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Lütfen ihtiyacınız olan destek türünü ve detaylarını eksiksiz doldurunuz.'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32),
              
              // Category Selection
              Text(
                'Kategori Seçimi'.tr(),
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface, // surface-container
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)), // outline-variant
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: Text('Kategori seçiniz'.tr(), style: TextStyle(color: AppColors.textSecondary)),
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceElevated,
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF7ADC75)),
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                    items: _categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.tr()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Title Input
              Text(
                'Talep Başlığı'.tr(),
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Örn: Tekerlekli Sandalye İhtiyacı'.tr(),
                  hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Başlık zorunludur'.tr() : null,
              ),
              SizedBox(height: 24),
              
              // Description Input
              Text(
                'Detaylı Açıklama'.tr(),
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                style: TextStyle(color: AppColors.textPrimary),
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Durumunuzu ve ihtiyacınızı detaylı bir şekilde açıklayınız...'.tr(),
                  hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Açıklama zorunludur'.tr() : null,
              ),
              SizedBox(height: 24),
              
              // Attachment Area (Premium Glassmorphism feel)
              Text(
                'Gerekli Belgeler (İsteğe Bağlı)'.tr(),
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF7ADC75).withOpacity(0.3), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A8025).withOpacity(0.2), // primary-container
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.cloud_upload, color: Color(0xFF7ADC75)),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belge Yüklemek İçin Tıklayın'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF7ADC75),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Öğrenci belgesi, doktor raporu vb. (Max 5MB)'.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ADC75), // primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF7ADC75).withOpacity(0.5),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Color(0xFF003908), strokeWidth: 2),
                        )
                      : Text(
                          'Talebi Gönder'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003908), // on-primary
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
