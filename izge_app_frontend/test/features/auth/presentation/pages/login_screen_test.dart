import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:izge_app_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:izge_app_frontend/core/widgets/custom_text_field.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders login screen elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Hoş Geldiniz'), findsOneWidget);
      expect(find.text('Devam etmek için giriş yapın'), findsOneWidget);
      expect(find.byType(CustomTextField), findsNWidgets(2)); // Email and Password fields
      expect(find.text('GİRİŞ YAP'), findsOneWidget);
    });

    testWidgets('entering phone number changes button to DOĞRULAMA KODU GÖNDER', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the email/phone text field (first CustomTextField)
      final emailOrPhoneField = find.byType(CustomTextField).first;

      // Enter a valid phone number
      await tester.enterText(emailOrPhoneField, '+905554443322');
      await tester.pumpAndSettle();

      // Check if button text changed
      expect(find.text('DOĞRULAMA KODU GÖNDER'), findsOneWidget);
      expect(find.text('GİRİŞ YAP'), findsNothing);

      // Check if password field is hidden (only 1 CustomTextField should be visible)
      expect(find.byType(CustomTextField), findsOneWidget);
      
      // Tap the button
      await tester.tap(find.text('DOĞRULAMA KODU GÖNDER'));
      await tester.pump();
      
      // Verify that AuthSendOtpRequested event is added
      verify(() => mockAuthBloc.add(const AuthSendOtpRequested(phone: '+905554443322'))).called(1);
    });
  });
}
