import 'package:flutter_test/flutter_test.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  group('SupabaseService', () {
    late SupabaseService supabaseService;
    late MockSupabaseClient mockSupabaseClient;
    late MockGoTrueClient mockAuthClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockAuthClient = MockGoTrueClient();
      
      when(() => mockSupabaseClient.auth).thenReturn(mockAuthClient);
      
      supabaseService = SupabaseService(client: mockSupabaseClient);
    });

    test('currentUser should return the user from client.auth', () {
      final mockUser = User(
        id: '123',
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
      );
      
      when(() => mockAuthClient.currentUser).thenReturn(mockUser);
      
      final result = supabaseService.currentUser;
      
      expect(result, equals(mockUser));
      verify(() => mockAuthClient.currentUser).called(1);
    });

    test('signInWithOtp should call auth.signInWithOtp', () async {
      when(() => mockAuthClient.signInWithOtp(
            phone: any(named: 'phone'),
          )).thenAnswer((_) async {});
          
      await supabaseService.signInWithOtp(phone: '+905554443322');
      
      verify(() => mockAuthClient.signInWithOtp(phone: '+905554443322')).called(1);
    });
  });
}
