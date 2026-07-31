import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izge_app_frontend/core/models/profile_model.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class MockSupabaseService extends Mock implements SupabaseService {}
class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockSupabaseService mockSupabaseService;

    final tProfile = ProfileModel(
      id: 'user_123',
      fullName: 'Test User',
      phone: '+905554443322',
      role: 'user',
      createdAt: DateTime.now(),
    );

    setUp(() {
      mockSupabaseService = MockSupabaseService();
      authBloc = AuthBloc(authService: mockSupabaseService);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthOtpSent] when AuthSendOtpRequested is added and succeeds',
      build: () {
        when(() => mockSupabaseService.signInWithOtp(
              phone: any(named: 'phone'),
            )).thenAnswer((_) async {});
        
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSendOtpRequested(
        phone: '5554443322',
      )),
      expect: () => [
        AuthLoading(),
        const AuthOtpSent(phone: '+905554443322', message: 'Doğrulama kodu gönderildi.'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthLoginRequested (with phone) succeeds',
      build: () {
        when(() => mockSupabaseService.signIn(
              phone: any(named: 'phone'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => MockAuthResponse());

        when(() => mockSupabaseService.getProfile())
            .thenAnswer((_) async => tProfile);
        
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        phone: '+905554443322',
        password: 'password123',
      )),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(tProfile),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when AuthCheckRequested fails (no user)',
      build: () {
        when(() => mockSupabaseService.currentUser).thenReturn(null);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        AuthLoading(),
        AuthUnauthenticated(),
      ],
    );
  });
}
