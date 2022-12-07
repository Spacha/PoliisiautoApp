import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:poliisiauto/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
   /* testWidgets('SOS button.',
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
      final Finder quit = find.textContaining('Lopeta lähetys');
      await tester.tap(quit);
      await tester.pumpAndSettle();

      // Confirm we are back to the front page.
      expect(find.text('Kirjaudu sisään'), findsOneWidget);
  });*/
    testWidgets('Forgotten password button.',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();
      //await tester.pump(const Duration(milliseconds: 8000));


      expect(find.text('Kirjaudu sisään'), findsOneWidget);
      final Finder loginButton = find.text('Kirjaudu sisään');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text('Kirjaudu Sisään'), findsOneWidget);
      final Finder forgotPassword = find.text('Unohtuiko salasana?');
      await tester.tap(forgotPassword);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey("forgotten e-mail")), 'testi.tunnus@s-posti.com');
      final Finder sendEmail = find.text('Lähetä salasanan uusimislinkki sähköpostiin.');
      await tester.tap(sendEmail);
      await tester.pumpAndSettle();

      // Confirm we are back to the front page.
      expect(find.text('Kirjaudu sisään'), findsOneWidget);
  });
    testWidgets('Log in and home page functionalities.',
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

      // Test New report button on front page, fill in information and send the report.
      final Finder newReportButton = find.text('Tee uusi ilmoitus');
      await tester.tap(newReportButton);
      await tester.pumpAndSettle();
      expect(find.text('Uusi ilmoitus'), findsOneWidget);

      // Write something to the text boxes:
      await tester.enterText(find.byKey(const ValueKey("What happened")), 
      'Minulla tuli kakka housuun ja ystäväni kiusasivat minua ja heittivät kivillä.');
      await tester.enterText(find.byKey(const ValueKey("Who was there")), 'Lauri ja Miika');

      // TODO: Test the teacher/adult selection (dropdown menu)

      // TODO: Test the anonymous selection button

      // Scroll the page down to make sure Lähetä button is visible when trying to press it.
      await tester.dragUntilVisible(
        find.textContaining(' Lähetä'),
        find.byKey(const ValueKey('scroll new report page')),
        const Offset(-250, 0),
      );
      final Finder sendReportButton = find.textContaining(' Lähetä');
      await tester.tap(sendReportButton);
      await tester.pumpAndSettle();

      // TODO: Check that the report is on MyReports.

      // Test New report button on front page and cancel the activity.
      expect(find.text('Etusivu'), findsOneWidget);
      await tester.tap(newReportButton);
      await tester.pumpAndSettle();
      expect(find.text('Uusi ilmoitus'), findsOneWidget);
      expect(find.text('Peruuta'), findsOneWidget);
      final Finder cancelNewReport = find.text('Peruuta');
      await tester.tap(cancelNewReport);
      await tester.pumpAndSettle();
      expect(find.text('Etusivu'), findsOneWidget);

      // Open all pages from all other pages using side bar.
      final Finder drawer = find.byTooltip('Open navigation menu');

      const iconList = [Icons.home, Icons.border_color, Icons.notifications, 
                        Icons.message, Icons.settings, Icons.person];
      const screenList = ["Etusivu", "Uusi ilmoitus", "Minun ilmoitukset", 
                          "Viestit", "Asetukset", "Minun tiedot"];
      for (var i=0; i<iconList.length; i++) {
        for (var j=0; j<iconList.length; j++) {
          if (i != j) {
            expect(drawer, findsWidgets);
            await tester.tap(drawer);
            await tester.pumpAndSettle();

            final Finder goToIcon = find.byIcon(iconList[j]);
            await tester.tap(goToIcon);
            await tester.pumpAndSettle();
            expect(find.text(screenList[j]), findsWidgets);

            expect(drawer, findsWidgets);
            await tester.tap(drawer);
            await tester.pumpAndSettle();

            final Finder goBackToIcon = find.byIcon(iconList[i]);
            await tester.tap(goBackToIcon);
            await tester.pumpAndSettle();
            expect(find.text(screenList[i]), findsWidgets);
            }
          else {
            // TODO: Test that page remains the same after clicking the button
          }
          }
        }

      // Log out.
      expect(drawer, findsWidgets);
      await tester.tap(drawer);
      await tester.pumpAndSettle();

      final Finder icon = find.byIcon(Icons.logout);
      await tester.tap(icon);
      await tester.pumpAndSettle();
      expect(find.text('Kirjaudu Sisään'), findsWidgets);  // TODO: this should maybe take user to front page, not to login page.
      });
  });
}