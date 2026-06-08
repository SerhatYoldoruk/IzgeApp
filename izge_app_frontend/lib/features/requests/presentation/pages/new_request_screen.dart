import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'package:izge_app_frontend/core/state/activity_state.dart';
import 'package:izge_app_frontend/features/requests/presentation/pages/request_success_screen.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  bool _isSubmitting = false;

  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Tekerlekli Sandalye Bakımı',
    'İlaç Yardımı',
    'Eğitim Desteği',
    'Psikolojik Destek',
    'Erzak Yardımı',
    'Kıyafet Yardımı',
    'Diğer',
  ];
  String _getCategorySlug(String category) {
    // Map visible category labels to DB-allowed `request_type` values
    switch (category) {
      case 'Tekerlekli Sandalye Bakımı':
      case 'Kıyafet Yardımı':
        return 'items';
      case 'İlaç Yardımı':
      case 'Psikolojik Destek':
        return 'health';
      case 'Eğitim Desteği':
        return 'education';
      case 'Erzak Yardımı':
        return 'food';
      case 'Diğer':
      default:
        return 'other';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close bottom sheet
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Dosya seçilemedi: $e')));
      }
    }
  }

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
                'Dosya Kaynağı Seçin'.tr(),
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A8025).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: const Color(0xFF1A8025)),
                ),
                title: Text(
                  'Kamera'.tr(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A8025).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: const Color(0xFF1A8025),
                  ),
                ),
                title: Text(
                  'Galeri'.tr(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() => _isSubmitting = true);

      try {
        final request = await SupabaseService.instance.createRequest(
          title: _titleController.text.trim(),
          description: _detailController.text.trim(),
          requestType: _getCategorySlug(_selectedCategory!),
        );

        ActivityState.instance.incrementRequestCount();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RequestSuccessScreen(request: request),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
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
                'Lütfen ihtiyacınız olan destek türünü ve detaylarını eksiksiz doldurunuz.'
                    .tr(),
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
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface, // surface-container
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.3),
                  ), // outline-variant
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: Text(
                      'Kategori seçiniz'.tr(),
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceElevated,
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF7ADC75)),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    items: _categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.tr()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        if (_titleController.text.isEmpty ||
                            _categories.contains(_titleController.text)) {
                          _titleController.text = newValue ?? '';
                        }
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Title Input
              Text(
                'Talep Başlığı'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Örn: Tekerlekli Sandalye İhtiyacı'.tr(),
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Başlık zorunludur'.tr()
                    : null,
              ),
              SizedBox(height: 24),

              // Description Input
              Text(
                'Detaylı Açıklama'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _detailController,
                style: TextStyle(color: AppColors.textPrimary),
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Durumunuzu ve ihtiyacınızı detaylı bir şekilde açıklayınız...'
                          .tr(),
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Açıklama zorunludur'.tr()
                    : null,
              ),
              SizedBox(height: 24),

              // Attachment Area (Premium Glassmorphism feel)
              Text(
                'Gerekli Belgeler (İsteğe Bağlı)'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _showFilePickerBottomSheet(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF7ADC75).withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedFile != null
                              ? const Color(0xFF1A8025).withOpacity(0.8)
                              : const Color(
                                  0xFF1A8025,
                                ).withOpacity(0.2), // primary-container
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _selectedFile != null
                              ? Icons.check_circle
                              : Icons.cloud_upload,
                          color: Color(0xFF7ADC75),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _selectedFile != null
                            ? (_selectedFile!.path.split('/').last.length > 25
                                  ? '...${_selectedFile!.path.split('/').last.substring(_selectedFile!.path.split('/').last.length - 25)}'
                                  : _selectedFile!.path.split('/').last)
                            : 'Belge Yüklemek İçin Tıklayın'.tr(),
                        style: TextStyle(
                          color: Color(0xFF7ADC75),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedFile == null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Öğrenci belgesi, doktor raporu vb. (Max 5MB)'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
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
                          child: CircularProgressIndicator(
                            color: Color(0xFF003908),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Talebi Gönder'.tr(),
                          style: TextStyle(
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
