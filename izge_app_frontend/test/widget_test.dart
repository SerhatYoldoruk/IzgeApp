import 'package:flutter_test/flutter_test.dart';

import 'package:izge_app_frontend/main.dart';

void main() {
  testWidgets('app opens on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const IzgeApp());

    expect(find.text('Hoş Geldiniz'), findsOneWidget);
    expect(find.text('GİRİŞ YAP'), findsOneWidget);
  });
}
