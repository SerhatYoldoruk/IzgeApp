import 'package:flutter/material.dart';

import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/widgets/custom_text_field.dart';
import 'package:izge_app_frontend/core/widgets/loading_overlay.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/sign_screen.dart';
import 'package:izge_app_frontend/features/navigation/presentation/pages/main_navigation_page.dart';

/// Giriş ekranı - kullanıcıların e-posta/telefon ve şifre ile oturum açması için
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // Sık kullanılan resimleri (logo, google) önceden yükle
    // Böylece ilk açılışta görsel gecikmeleri azaltırız
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/images/logo.jpeg'), context);
      precacheImage(const AssetImage('assets/images/images/google_logo.png'), context);
    });
  }

  /// Kullanıcı tarafından girilen e-posta veya telefon numarası
  String emailOrPhone = '';
  
  /// Kullanıcı tarafından girilen şifre
  String password = '';
  


  /// E-posta veya telefon numarası ile giriş işlemini başlat
  void _handleLogin() {
    if (emailOrPhone.isEmpty || password.isEmpty) {
      _showMessage('Lütfen e-posta/telefon ve şifrenizi girin.');
      return;
    }

    final isEmail = emailOrPhone.contains('@');
    
    context.read<AuthBloc>().add(AuthLoginRequested(
      email: isEmail ? emailOrPhone : null,
      phone: !isEmail ? emailOrPhone : null,
      password: password,
    ));
  }

  /// Google OAuth ile giriş işlemini başlat
  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(AuthGoogleSignInRequested());
  }

  /// Ekranda SnackBar mesajı göster (bilgi, uyarı, hata vb.)
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars() // Önceki mesajları temizle
      ..showSnackBar(SnackBar(content: Text(message))); // Yeni mesajı göster
  }

  /// İngilizce Supabase hata mesajlarını Türkçeye çevir
  /// Supabase API'den gelen İngilizce hatalar kullanıcı dostu Türkçe metne dönüştürülür
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
    return translations[message] ?? message;
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showMessage(_translateAuthError(state.message));
        } else if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return LoadingOverlay(
          isLoading: isLoading,
          message: 'Giriş yapılıyor...',
          child: Scaffold(
            backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  
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
                    'Hoş Geldiniz',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Devam etmek için giriş yapın',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          hintText: 'E-posta veya telefon numaranızı giriniz',
                          prefixIcon: Icons.person_outline,
                          onChanged: (value) => setState(() => emailOrPhone = value),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Şifrenizi giriniz',
                          prefixIcon: Icons.lock_outline,
                          onChanged: (value) => setState(() => password = value),
                          obscureText: true,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Şifremi unuttum',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
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
                                    'GİRİŞ YAP',
                                    style: TextStyle(
                                      color: AppColors.accentOnPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        const _DividerLabel(),
                        const SizedBox(height: 24),
                        
                        _GoogleSignInCard(
                          onTap: isLoading ? null : _handleGoogleSignIn,
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // "KAYIT OL" Butonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Henüz üye değil misiniz? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const SignPage()),
                          );
                        },
                        child: Text(
                          'KAYIT OL',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
        );
      },
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        const SizedBox(width: 16),
        Text(
          'VEYA',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }
}

class _GoogleSignInCard extends StatelessWidget {
  const _GoogleSignInCard({this.onTap, this.isLoading = false});

  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(16),
            color: AppColors.surface,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  'assets/images/images/google_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isLoading ? 'Lütfen bekleyin...' : 'Google ile giriş yap',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
