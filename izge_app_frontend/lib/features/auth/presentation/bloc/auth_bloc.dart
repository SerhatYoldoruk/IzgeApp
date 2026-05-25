import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseService _authService;

  AuthBloc({SupabaseService? authService}) 
      : _authService = authService ?? SupabaseService.instance,
        super(AuthInitial()) {
    
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final profile = await _authService.getProfile();
        emit(AuthAuthenticated(profile));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.signIn(
        email: event.email,
        phone: event.phone,
        password: event.password,
      );
      final profile = await _authService.getProfile();
      emit(AuthAuthenticated(profile));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.signUp(
        email: event.email,
        phone: event.phone,
        password: event.password,
        data: {
          'full_name': event.fullName,
        },
      );
      
      if (response.session == null) {
        // Otomatik giriş yapılmadı, muhtemelen e-posta onayı gerekiyor
        emit(const AuthSignUpSuccess('Kayıt başarılı! Lütfen e-posta adresinize gönderilen onay bağlantısına tıklayın.'));
      } else {
        final profile = await _authService.getProfile();
        emit(AuthAuthenticated(profile));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
      AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        // OAuth redirection might cause app restart, but just in case it's in-app:
        final profile = await _authService.getProfile();
        emit(AuthAuthenticated(profile));
      } else {
        emit(const AuthError('Google ile giriş başarısız oldu.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Supabase.instance.client.auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
