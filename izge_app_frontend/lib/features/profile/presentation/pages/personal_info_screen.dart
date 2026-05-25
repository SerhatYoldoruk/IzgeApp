import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/change_photo_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;
  bool _isFetching = true;
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => _isFetching = false);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (response != null) {
        _nameController.text = response['full_name'] ?? response['name'] ?? '';
        _phoneController.text = response['phone'] ?? '';
        _addressController.text = response['address'] ?? '';
        _avatarUrl = response['avatar_url'] ?? '';
      }
    } catch (e) {
      _nameController.text = user.userMetadata?['name'] ?? '';
      _avatarUrl = user.userMetadata?['avatar_url'] ?? '';
    } finally {
      _emailController.text = user.email ?? '';
      setState(() => _isFetching = false);
    }
  }

  void _handleSave() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updates = {
        'full_name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      // Eğer adres alanı doldurulduysa payload'a ekle
      if (_addressController.text.trim().isNotEmpty) {
        updates['address'] = _addressController.text.trim();
      }

      await Supabase.instance.client
          .from('profiles')
          .update(updates)
          .eq('id', user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Bilgileriniz başarıyla kaydedildi!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: const Color(0xFF1A8025),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(24),
          elevation: 8,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Eğer adres kolonu eksik hatası verirse, adresi hariç tutup sadece isim ve telefonu kaydetmeyi dener
      if (e.toString().contains('address')) {
        try {
          await Supabase.instance.client.from('profiles').update({
            'full_name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
          }).eq('id', user.id);

          if (!mounted) return;
          Navigator.pop(context);
          return;
        } catch (_) {}
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.surface,
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
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 100),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      // DÜZELTİLDİ: Kullanıcının fotoğraf değiştirme ekranından geri çıkmasını bekliyoruz
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePhotoScreen()),
                      );
                      // DÜZELTİLDİ: Geri döndüğü an (hiçbir şeye basmasa bile) verileri veritabanından tekrar çekip sayfayı yeniliyoruz
                      _loadUserData();
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
                                  color: AppColors.surface,
                                  border: Border.all(color: AppColors.surface, width: 4),
                                ),
                                child: ClipOval(
                                  child: _avatarUrl.isNotEmpty
                                      ? Image.network(
                                          _avatarUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.person,
                                            size: 64,
                                            color: AppColors.textSecondary,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 64,
                                          color: AppColors.textSecondary,
                                        ),
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
                                    color: const Color(0xFF1A8025),
                                    border: Border.all(color: AppColors.background, width: 4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.photo_camera,
                                    color: Color(0xFFD3FFC8),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                    readOnly: true,
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
                        backgroundColor: const Color(0xFF1A8025),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
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
    bool readOnly = false,
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
          readOnly: readOnly,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
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
            fillColor: AppColors.surface,
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
              borderSide: BorderSide(color: readOnly ? Colors.transparent : const Color(0xFF1A8025), width: 2),
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