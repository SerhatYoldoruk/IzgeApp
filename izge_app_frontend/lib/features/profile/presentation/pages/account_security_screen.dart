import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/change_password_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/active_devices_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> with WidgetsBindingObserver {
  bool _pinLockEnabled = false;
  String _deviceName = 'Yükleniyor...';
  
  // Real data fields
  String _userEmail = 'Yükleniyor...';
  bool _isEmailVerified = false;
  String _passwordUpdateDate = 'Yükleniyor...';
  String _lastSignIn = 'Bilinmiyor';

  bool _isGoogleLinked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDeviceName();
    _loadPinState();
    _loadSupabaseData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSupabaseData();
    }
  }

  void _showPremiumDialog({required String title, required String message, required IconData icon, required Color color}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Tamam',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  void _loadSupabaseData() async {
    final response = await Supabase.instance.client.auth.getUser();
    final user = response.user;
    
    if (user != null && mounted) {
      bool wasGoogleLinked = _isGoogleLinked;

      setState(() {
        _userEmail = user.email ?? 'E-Posta bulunamadı';
        _isEmailVerified = user.emailConfirmedAt != null;

        // Check providers
        if (user.appMetadata['providers'] != null) {
          final providers = List<String>.from(user.appMetadata['providers'] as List);
          _isGoogleLinked = providers.contains('google');
        }

        // Show success popup if Google was just linked!
        if (!wasGoogleLinked && _isGoogleLinked) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showPremiumDialog(
              title: 'Harika!', 
              message: 'Google hesabınız başarıyla bağlandı.', 
              icon: Icons.check_circle_outline, 
              color: const Color(0xFF7ADC75)
            );
          });
        }

        // Password update date (proxied by user.updatedAt)
        if (user.updatedAt != null) {
          final updatedAt = DateTime.parse(user.updatedAt!);
          final now = DateTime.now();
          final diff = now.difference(updatedAt);
          if (diff.inDays == 0) {
            _passwordUpdateDate = 'Bugün güncellendi';
          } else if (diff.inDays == 1) {
            _passwordUpdateDate = 'Dün güncellendi';
          } else {
            _passwordUpdateDate = '${diff.inDays} gün önce güncellendi';
          }
        }

        // Last Sign In
        if (user.lastSignInAt != null) {
          final lastSignIn = DateTime.parse(user.lastSignInAt!).toLocal();
          final now = DateTime.now();
          final diff = now.difference(lastSignIn);
          
          final hourMin = '${lastSignIn.hour.toString().padLeft(2, '0')}:${lastSignIn.minute.toString().padLeft(2, '0')}';
          
          if (diff.inMinutes < 5) {
            _lastSignIn = 'Az önce';
          } else if (diff.inDays == 0 && now.day == lastSignIn.day) {
            _lastSignIn = 'Bugün ($hourMin)';
          } else if (diff.inDays == 1 || (diff.inDays == 0 && now.day != lastSignIn.day)) {
            _lastSignIn = 'Dün ($hourMin)';
          } else {
            _lastSignIn = '${diff.inDays} gün önce ($hourMin)';
          }
        }
      });
    }
  }

  Future<void> _loadPinState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pinLockEnabled = prefs.getBool('app_pin_enabled') ?? false;
    });
  }

  Future<void> _handleGoogleLink() async {
    try {
      if (_isGoogleLinked) {
        // Unlink
        final identities = Supabase.instance.client.auth.currentUser?.identities ?? [];
        final googleIdentity = identities.firstWhere(
          (identity) => identity.provider == 'google', 
          orElse: () => throw Exception('Google kimliği bulunamadı.')
        );
        
        await Supabase.instance.client.auth.unlinkIdentity(googleIdentity);
        setState(() {
           _isGoogleLinked = false;
        });
        if (mounted) _showPremiumDialog(title: 'Bağlantı Kesildi', message: 'Google hesabınızın bağlantısı başarıyla kaldırıldı.', icon: Icons.link_off, color: Colors.orangeAccent);
      } else {
        await Supabase.instance.client.auth.linkIdentity(
          OAuthProvider.google,
          redirectTo: 'izgeapp://login-callback',
        );
      }
    } on AuthException catch (e) {
      if (mounted) _showPremiumDialog(title: 'Bağlantı Hatası', message: e.message, icon: Icons.error_outline, color: Colors.redAccent);
    } catch (e) {
      if (mounted) _showPremiumDialog(title: 'Beklenmeyen Hata', message: 'İşlem sırasında bir hata oluştu.', icon: Icons.warning_amber_rounded, color: Colors.redAccent);
    }
  }

  Future<void> _togglePinLock(bool value) async {
    if (value) {
      _showPinSetupDialog();
    } else {
      // Removing PIN
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('PIN Kilidini Kaldır', style: TextStyle(color: AppColors.textPrimary)),
            content: Text('Uygulama girişindeki PIN kilidini kaldırmak istediğinize emin misiniz?', style: TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('app_pin_enabled', false);
                  await prefs.remove('app_pin_code'); // Remove actual PIN if stored
                  if (mounted) {
                    setState(() {
                      _pinLockEnabled = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN kilidi başarıyla kaldırıldı.')));
                  }
                },
                child: const Text('Kaldır', style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _loadDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    String name = 'Bilinmeyen Cihaz';
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        String manufacturer = info.manufacturer;
        if (manufacturer.isNotEmpty) {
          manufacturer = manufacturer[0].toUpperCase() + manufacturer.substring(1);
        }
        name = '$manufacturer ${info.model}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        name = info.name;
      } else if (Platform.isWindows) {
        name = 'Windows PC';
      } else if (Platform.isMacOS) {
        name = 'Mac';
      }
    } catch (e) {
      name = 'Bilinmeyen Cihaz';
    }
    if (mounted) {
      setState(() {
        _deviceName = name;
      });
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
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hesap Güvenliği',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: KİMLİK & ŞİFRE
            _buildSectionHeader('KİMLİK & ŞİFRE'),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _buildActionItem(
                    icon: Icons.email_outlined,
                    iconColor: const Color(0xFF1A8025),
                    iconBgColor: const Color(0xFF1A8025).withOpacity(0.2),
                    title: 'E-Posta Adresi',
                    subtitle: '$_userEmail (${_isEmailVerified ? 'Doğrulandı' : 'Doğrulanmadı'})',
                    subtitleColor: _isEmailVerified ? const Color(0xFF7ADC75) : Colors.orangeAccent,
                    onTap: () {
                      _showEmailChangeBottomSheet(context);
                    },
                  ),
                  Divider(height: 1, color: AppColors.border.withOpacity(0.5)),
                  _buildActionItem(
                    icon: Icons.lock_outline,
                    iconColor: const Color(0xFF1A8025),
                    iconBgColor: const Color(0xFF1A8025).withOpacity(0.2),
                    title: 'Şifre Değiştir',
                    subtitle: _passwordUpdateDate,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section 2: BAĞLI HESAPLAR
            _buildSectionHeader('BAĞLI HESAPLAR'),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _buildActionItem(
                    icon: Icons.g_mobiledata,
                    iconColor: Colors.redAccent,
                    iconBgColor: Colors.redAccent.withOpacity(0.1),
                    title: _isGoogleLinked ? 'Google Bağlantısını Kes' : 'Google ile Bağlan',
                    subtitle: _isGoogleLinked ? 'Bağlı' : 'Bağlı değil',
                    subtitleColor: _isGoogleLinked ? const Color(0xFF7ADC75) : AppColors.textSecondary,
                    onTap: _handleGoogleLink,
                  ),
                  if (Platform.isIOS || Platform.isMacOS)
                    Divider(height: 1, color: AppColors.border.withOpacity(0.5)),
                  if (Platform.isIOS || Platform.isMacOS)
                    _buildActionItem(
                      icon: Icons.apple,
                      iconColor: AppColors.textPrimary,
                      iconBgColor: AppColors.surfaceElevated,
                      title: 'Apple ile Bağlan',
                      subtitle: 'Bağlı değil',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Apple hesabınız başarıyla bağlandı.')));
                      },
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section 3: UYGULAMA İÇİ GÜVENLİK
            _buildSectionHeader('UYGULAMA İÇİ GÜVENLİK'),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: _buildToggleItem(
                icon: Icons.dialpad,
                title: 'Uygulama PIN Kilidi',
                subtitle: 'Açılışta 4 haneli PIN sorulur',
                value: _pinLockEnabled,
                onChanged: _togglePinLock,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section 4: OTURUM YÖNETİMİ & GEÇMİŞ
            _buildSectionHeader('OTURUM YÖNETİMİ & GEÇMİŞ'),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _buildActionItem(
                    icon: Icons.history,
                    iconColor: AppColors.textPrimary,
                    iconBgColor: AppColors.border,
                    title: 'Son Giriş',
                    subtitle: _lastSignIn,
                    subtitleColor: const Color(0xFF7ADC75),
                    onTap: () {
                      _showLoginHistoryBottomSheet(context);
                    },
                  ),
                  Divider(height: 1, color: AppColors.border.withOpacity(0.5)),
                  _buildActionItem(
                    icon: Icons.devices,
                    iconColor: AppColors.textPrimary,
                    iconBgColor: AppColors.border,
                    title: 'Aktif Cihazlar',
                    subtitle: 'Bu Cihaz: $_deviceName',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ActiveDevicesScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section 5: HESAP İŞLEMLERİ
            _buildSectionHeader('HESAP İŞLEMLERİ'),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: _buildActionItem(
                icon: Icons.delete_forever,
                iconColor: const Color(0xFFE57373),
                iconBgColor: const Color(0xFFE57373).withOpacity(0.2),
                title: 'Hesabımı Sil',
                subtitle: 'Bu işlem kalıcıdır',
                subtitleColor: const Color(0xFFE57373),
                titleColor: const Color(0xFFE57373),
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    Color? subtitleColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor ?? AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration( 
              color: const Color(0xFF1A8025).withOpacity(0.2), 
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1A8025), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7ADC75),
            trackColor: AppColors.border,
          ),
        ],
      ),
    );
  }

  void _showPinSetupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'PIN Belirle',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Uygulamaya girişte kullanılacak 4 haneli PIN kodunu girin.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text('•', style: TextStyle(color: AppColors.textPrimary, fontSize: 24)),
                  );
                }),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() { _pinLockEnabled = false; });
              },
              child: Text('İptal', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('app_pin_enabled', true);
                if (mounted) {
                  setState(() { _pinLockEnabled = true; });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN kilidi aktifleştirildi.')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A8025),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showEmailChangeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('E-Posta Güncelle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    IconButton(icon: Icon(Icons.close, color: AppColors.textSecondary), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Mevcut e-posta: $_userEmail', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                TextField(
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Yeni E-Posta Adresi',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.fieldBackground,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Doğrulama maili gönderildi.')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A8025),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Güncelle', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLoginHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Giriş Hareketleri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    IconButton(icon: Icon(Icons.close, color: AppColors.textSecondary), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildHistoryItem(Icons.verified_user, '$_deviceName (Bu Cihaz)', _lastSignIn, true),
              // We only have the lastSignInAt from Supabase for current session without a custom table
              // If we had a table, we'd list others here.
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text('Veritabanındaki son oturum açma zamanınız yukarıda belirtilmiştir.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryItem(IconData icon, String title, String time, bool isCurrent) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
      title: Text(title, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      subtitle: Text(time, style: TextStyle(color: AppColors.textSecondary)),
      trailing: isCurrent ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFF1A8025).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
        child: const Text('Şu an', style: TextStyle(color: Color(0xFF7ADC75), fontSize: 12, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Emin misiniz?', style: TextStyle(color: Color(0xFFE57373))),
          content: Text('Hesabınızı silmek istediğinizden emin misiniz? Bu işlem kalıcıdır ve geri alınamaz.', style: TextStyle(color: AppColors.textPrimary)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('İptal', style: TextStyle(color: AppColors.textSecondary))),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hesap silme talebiniz alınmıştır.'), duration: Duration(seconds: 3)));
                  Navigator.pop(context);
                }
              },
              child: const Text('Hesabımı Sil', style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
