import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:poliisiauto/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Check LogIn functionality.',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify login widget functionality
      expect(find.text('Kirjaudu sisään'), findsOneWidget);
      final Finder loginButton = find.text('Kirjaudu sisään');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text('Kirjaudu Sisään'), findsOneWidget);

      // Try logging in with test credentials.
      await tester.enterText(find.byKey(const ValueKey("username")), 'testitunnus');
      await tester.enterText(find.byKey(const ValueKey("password")), 'testisalasana');
      final Finder loginButton2 = find.text('Kirjaudu');
      await tester.tap(loginButton2);
      await tester.pumpAndSettle();
      expect(find.text('Etusivu'), findsOneWidget);
    });
  });
}