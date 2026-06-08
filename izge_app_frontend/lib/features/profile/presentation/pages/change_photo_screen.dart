import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';

class ChangePhotoScreen extends StatefulWidget {
  const ChangePhotoScreen({super.key});

  @override
  State<ChangePhotoScreen> createState() => _ChangePhotoScreenState();
}

class _ChangePhotoScreenState extends State<ChangePhotoScreen> {
  bool _isLoading = false;
  File? _imageFile;
  String _currentAvatarUrl = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCurrentAvatar();
  }

  Future<void> _loadCurrentAvatar() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url') // KESİN ÇÖZÜM: 'avatar_url' olarak güncellendi
          .eq('id', user.id)
          .single();
      if (response['avatar_url'] != null) {
        setState(() {
          _currentAvatarUrl = response['avatar_url'];
        });
      }
    } catch (_) {}
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackBar('Resim seçilemedi: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _removeCurrentPhoto() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': null}).eq('id', user.id); // KESİN ÇÖZÜM: 'avatar_url' olarak güncellendi

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'avatar_url': null,
          },
        ),
      );

      _showSnackBar('Profil fotoğrafı kaldırıldı!', const Color(0xFF1A8025));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Fotoğraf kaldırılırken hata oluştu.', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSave() async {
    if (_imageFile == null) {
      _showSnackBar('Lütfen önce bir fotoğraf çekin veya seçin!', Colors.orange);
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = fileName;

      // 1. Supabase Storage'a resmi senin paneline göre 'avatar' bucket'ına yüklüyoruz
      await Supabase.instance.client.storage
          .from('avatar')
          .upload(path, _imageFile!);

      // 2. Yüklenen resmin Public URL'ini alıyoruz
      final String publicUrl = Supabase.instance.client.storage
          .from('avatar')
          .getPublicUrl(path);

      // 3. Veritabanındaki profiles tablosunda senin sütununa yazıyoruz
      // KESİN ÇÖZÜM: 'avatar_url' sütun ismiyle güncellendi
      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': publicUrl}).eq('id', user.id);

      // Update auth.users metadata for avatar
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'avatar_url': publicUrl,
          },
        ),
      );

      _showSnackBar('Profil fotoğrafı güncellendi!', const Color(0xFF1A8025));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Hata Detayı: ${e.toString()}', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color bgColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
        elevation: 8,
      ),
    );
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
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated,
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
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : _currentAvatarUrl.isNotEmpty
                                ? Image.network(
                                    _currentAvatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Icon(
                                      Icons.person,
                                      size: 80,
                                      color: AppColors.textSecondary,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 80,
                                    color: AppColors.textSecondary,
                                  ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Profil fotoğrafınız toplulukta nasıl göründüğünüzü belirler.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildOptionCard(
                      icon: Icons.photo_camera,
                      title: 'Fotoğraf Çek',
                      subtitle: 'Kameranızı kullanarak yeni bir fotoğraf çekin',
                      iconBgColor: const Color(0xFF1A8025),
                      iconColor: const Color(0xFFD3FFC8),
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      icon: Icons.image,
                      title: 'Galeriden Seç',
                      subtitle: 'Cihazınızdaki fotoğraflar arasından seçim yapın',
                      iconBgColor: AppColors.border,
                      iconColor: AppColors.textPrimary,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(height: 24),
                    _buildOptionCard(
                      icon: Icons.delete,
                      title: 'Mevcut Fotoğrafı Kaldır',
                      subtitle: null,
                      iconBgColor: const Color(0xFF93000A).withOpacity(0.3),
                      iconColor: const Color(0xFFFFB4AB),
                      titleColor: const Color(0xFFFFB4AB),
                      onTap: _removeCurrentPhoto,
                      showChevron: false,
                    ),
                  ],
                ),
              ),
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
                    backgroundColor: const Color(0xFF1A8025),
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
        color: AppColors.surface,
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
                const SizedBox(width: 16),
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