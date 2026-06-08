import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/widgets/custom_text_field.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/registration_success_screen.dart';

/// Kayıt Ekranı - yeni kullanıcıların hesap oluşturması için
class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  /// Kullanıcı adı / soyadı
  String name = '';
  
  /// Kayıt olacak e-posta adresi
  String email = '';
  
  /// Kayıt olacak telefon numarası
  String phone = '';
  
  /// Şifre
  String password = '';
  
  /// Şifre tekrar (doğrulama için)
  String confirmPassword = '';
  
  /// KVKK (Kişisel Verilerin Korunması Kanunu) onayı
  bool kvkkKabul = false;
  
  /// Kullanım şartları onayı
  bool sartlarKabul = false;

  /// Kayıt işlemini gerçekleştir
  void _handleSignUp() {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Lütfen tüm alanları doldurunuz.');
      return;
    }
    if (password != confirmPassword) {
      _showMessage('Şifreler eşleşmiyor.');
      return;
    }
    if (!kvkkKabul || !sartlarKabul) {
      _showMessage('Lütfen KVKK ve Kullanım Şartlarını kabul ediniz.');
      return;
    }

    TextInput.finishAutofillContext();

    context.read<AuthBloc>().add(AuthSignUpRequested(
      fullName: name.trim(),
      email: email.trim().contains('@') ? email.trim() : null,
      phone: !email.trim().contains('@') ? email.trim() : null, // If user typed phone in email field
      password: password,
    ));
  }

  /// Ekranda SnackBar mesajı göster
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars() // Önceki mesajları temizle
      ..showSnackBar(SnackBar(content: Text(message))); // Yeni mesajı göster
  }

  /// İngilizce Supabase hata mesajlarını Türkçeye çevir
  String _translateAuthError(String message) {
    final translations = {
      'Email not confirmed': 'E-posta doğrulanmadı',
      'Invalid login credentials': 'Geçersiz giriş bilgileri',
      'User not found': 'Kullanıcı bulunamadı',
      'Invalid credentials': 'Geçersiz kimlik bilgileri',
      'Email already registered': 'E-posta zaten kayıtlı',
      'User already exists': 'Kullanıcı zaten var',
      'Weak password': 'Şifre çok zayıf',
    };
    // Çevirisi varsa çevriltilmiş metni döndür, yoksa orijinal metni döndür
    for (final entry in translations.entries) {
      if (message.contains(entry.key)) {
        return entry.value;
      }
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showMessage('Kayıt hatası: ${_translateAuthError(state.message)}');
        } else if (state is AuthSignUpSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RegistrationSuccessScreen()),
          );
        } else if (state is AuthAuthenticated) {
          _showMessage('Kayıt başarılı!');
          final navigator = Navigator.of(context); // async gap öncesi yakala
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Glowing Logo
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/images/logo.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Başlıklar
                  Text(
                    'Hesap Oluştur',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aramıza katılmak için formu doldurun',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Form Kartı
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: 'İsminizi giriniz',
                            prefixIcon: Icons.person_outline,
                            onChanged: (value) => setState(() => name = value),
                            autofillHints: const [AutofillHints.name],
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'E-posta adresinizi giriniz',
                            prefixIcon: Icons.email_outlined,
                            onChanged: (value) => setState(() => email = value),
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: '05xx xxx xx xx',
                            prefixIcon: Icons.phone_outlined,
                            onChanged: (value) => setState(() => phone = value),
                            autofillHints: const [AutofillHints.telephoneNumber],
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'Şifrenizi giriniz',
                            prefixIcon: Icons.lock_outline,
                            onChanged: (value) => setState(() => password = value),
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 6, left: 4, bottom: 16),
                            child: Text(
                              '* Şifreniz en az 6 karakter uzunluğunda olmalıdır.',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                          CustomTextField(
                            hintText: 'Şifrenizi tekrar giriniz',
                            prefixIcon: Icons.lock_outline,
                            onChanged: (value) => setState(() => confirmPassword = value),
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                          ),
                        
                        const SizedBox(height: 24),
                        
                        _ConsentRow(
                          value: kvkkKabul,
                          title: 'KVKK Aydınlatma Metni\'ni okudum ve kabul ediyorum',
                          dialogTitle: 'KVKK Aydınlatma Metni',
                          dialogBody: '6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") uyarınca, İzge Derneği olarak veri sorumlusu sıfatıyla kişisel verilerinizi güvenle işliyor ve koruyoruz.\n\n1. Verilerin İşlenme Amacı\nAdınız, iletişim bilgileriniz ve sağladığınız diğer veriler, yardım faaliyetlerinin yürütülmesi, dernek etkinlikleri hakkında bilgilendirme yapılması ve yasal yükümlülüklerimizin yerine getirilmesi amacıyla işlenmektedir.\n\n2. Verilerin Aktarımı\nKişisel verileriniz, yasal zorunluluklar haricinde hiçbir üçüncü taraf veya kurumla ticari amaçla paylaşılmamaktadır.\n\n3. Haklarınız\nKVKK\'nın 11. maddesi uyarınca; verilerinizin işlenip işlenmediğini öğrenme, düzeltilmesini veya silinmesini talep etme hakkına sahipsiniz.',
                          onChanged: (value) => setState(() => kvkkKabul = value),
                        ),
                        const SizedBox(height: 8),
                        _ConsentRow(
                          value: sartlarKabul,
                          title: 'Kullanım Şartları\'nı okudum ve kabul ediyorum',
                          dialogTitle: 'Kullanım Şartları',
                          dialogBody: 'İzge Uygulaması\'na hoş geldiniz. Uygulamamızı kullanarak aşağıdaki şartları kabul etmiş sayılırsınız:\n\n1. Hizmet Kullanımı\nKullanıcılar, uygulamayı yasalara ve dernek amaçlarına uygun olarak kullanmayı taahhüt eder. Gerçeğe aykırı yardım talepleri oluşturmak yasaktır.\n\n2. Hesap Güvenliği\nHesap bilgilerinizin ve şifrenizin güvenliğinden tamamen siz sorumlusunuz.\n\n3. Sorumluluk Reddi\nDerneğimiz, uygulama üzerinden yapılan gönüllü yardımlaşmaların koordinasyonunu sağlar. İki taraf arasındaki uyuşmazlıklarda yasal sorumluluk taraflara aittir.\n\n4. Fesih\nKurallara uymayan kullanıcıların hesapları önceden haber verilmeksizin askıya alınabilir veya silinebilir.',
                          onChanged: (value) => setState(() => sartlarKabul = value),
                        ),
                      ],
                    ),
                  ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // KAYIT OL Butonu
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.accentOnPrimary,
                              ),
                            )
                          : Text(
                              'KAYIT OL',
                              style: TextStyle(
                                color: AppColors.accentOnPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Onay Checkbox Satırı - KVKK ve Şartlar için
/// Checkbox + Tıklanabilir Metin şeklinde kurulmuş
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.value,
    required this.title,
    required this.dialogTitle,
    required this.dialogBody,
    required this.onChanged,
  });

  /// Checkbox'un durumudurum (işaretlenmiş mi)
  final bool value;
  
  /// Checkbox yanında gösterilecek başlık (örn. "KVKK Onayı")
  final String title;
  
  /// Dialog penceresinin başlığı
  final String dialogTitle;
  
  /// Dialog penceresinin içeriği (detaylı açıklama)
  final String dialogBody;
  
  /// Checkbox değiştiğinde çağrılacak callback
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: (checked) => onChanged(checked ?? false),
          activeColor: AppColors.primary,
          checkColor: AppColors.accentOnPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(color: AppColors.border, width: 2),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 16),
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          dialogTitle,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text(
                            dialogBody,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              onChanged(true); // Otomatik kabul ettir
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Okudum, Onaylıyorum',
                              style: TextStyle(
                                color: AppColors.accentOnPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '${title.split('\'').first}\'',
                    style: TextStyle(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: title.split('\'').length > 1 ? title.substring(title.indexOf('\'') + 1) : '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
