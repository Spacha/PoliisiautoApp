import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:poliisiauto/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Tap on the SOS button, verify screen change',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the SOS widget exists on front page and it functions correctly.
      expect(find.text('Kirjaudu sisään'), findsOneWidget);
      final Finder sos1 = find.text('SOS');
      await tester.tap(sos1);
      await tester.pumpAndSettle();

      // Check SOS confirmation functionality.
      expect(find.text('Klikkaa painiketta\nuudelleen jos\nhaluat lähettää\nSOS -ilmoituksen'), findsOneWidget);
      final Finder sos2 = find.text('SOS');
      await tester.tap(sos2);
      await tester.pumpAndSettle();

      // Confirm we are at the SOS page.
      expect(find.text('SOS ilmoitusta lähetetään'), findsOneWidget);
      final Finder quit = find.text('   Lopeta lähetys   ');
      await tester.tap(quit);
      await tester.pumpAndSettle();

      // Confirm we are back to the front page.
      expect(find.text('Kirjaudu sisään'), findsOneWidget);
    });
  });
}