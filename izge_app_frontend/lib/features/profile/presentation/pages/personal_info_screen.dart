import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/change_photo_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Ahmet Yılmaz');
  final TextEditingController _emailController = TextEditingController(text: 'ahmet.yilmaz@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '+90 5XX XXX XX XX');
  final TextEditingController _addressController = TextEditingController();

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
            Text('Bilgileriniz başarıyla kaydedildi!', style: TextStyle(fontWeight: FontWeight.bold)),
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kişisel Bilgiler',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 100),
        child: Column(
          children: [
            // Profile Picture Section
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePhotoScreen()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Column(
                  children: [
                    Stack(
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface, // surface-container
                          border: Border.all(color: AppColors.surface, width: 4),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A8025), // primary-container
                            border: Border.all(color: AppColors.background, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.photo_camera,
                            color: Color(0xFFD3FFC8), // on-primary-container
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fotoğrafı Değiştir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ),
            
            const SizedBox(height: 32),
            
            // Form Fields
            _buildInputField(
              label: 'Ad Soyad',
              icon: Icons.person,
              controller: _nameController,
              hintText: 'Adınız Soyadınız',
            ),
            const SizedBox(height: 16),
            
            _buildInputField(
              label: 'E-posta',
              icon: Icons.mail,
              controller: _emailController,
              hintText: 'E-posta adresiniz',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            _buildInputField(
              label: 'Telefon',
              icon: Icons.call,
              controller: _phoneController,
              hintText: 'Telefon numaranız',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            _buildInputField(
              label: 'Adres',
              icon: Icons.home,
              controller: _addressController,
              hintText: 'Açık adresiniz...',
              maxLines: 3,
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleSave,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF003908),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save, color: Color(0xFF003908)),
                label: Text(
                  _isLoading ? 'Kaydediliyor...' : 'Kaydet',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003908),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A8025), // primary-container
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 32), // bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.surface, // surface-container
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.transparent, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.transparent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFF1A8025), width: 2), // primary-container focus
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16, 
              vertical: maxLines > 1 ? 16 : 18,
            ),
          ),
        ),
      ],
    );
  }
}
