import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:poliisiauto/main.dart' as app;
// import 'package:poliisiauto/src/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  // tester.pumpAndSettle has Duration (1s) set for tester friendliness, it is
  // then easier to follow. Duration is only necessary when the app is launched
  // and we need to wait for the splash screen to close (set to 5s). Another option
  // is to make a splash screen wait.
  group('end-to-end test', () {
    testWidgets('Forgot password ', (tester) async {app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the "Unohtuiko salasana?" button on login page and tap it
      expect(find.text('Unohtuiko salasana?'), findsOneWidget);
      final Finder forgotPasswordButton = find.text('Unohtuiko salasana?');
      await tester.tap(forgotPasswordButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Check that the screen is correct and return to login page
      expect(find.text('Unohditko salasanasi?'), findsOneWidget);
      final Finder goBack = find.byIcon(Icons.arrow_back);
      await tester.tap(goBack);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Confirm we are back to the front page.
      expect(find.text('Kirjaudu'), findsOneWidget);
  });
    testWidgets('Log in to a test teacher account and check page contents.', (tester) async {app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Kirjaudu sisään'), findsOneWidget);

      // Try logging in with test credentials.
      final Finder debugTeacherButton = find.byKey(const ValueKey("debug teacher"));
      await tester.tap(debugTeacherButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      /* USE THESE LINES FOR LOG IN ONCE DEBUG USERS ARE REMOVED FROM THE LOG IN -PAGE:
      await tester.enterText(find.byKey(const ValueKey("e-mail")), 'olli.o@esimerkki.fi');
      await tester.enterText(find.byKey(const ValueKey("password")), 'salasana');
      */
      final Finder loginButton2 = find.text('Kirjaudu');
      await tester.tap(loginButton2);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Test emergency floating button on front page
      for (var i=0; i<2; i++) {
        expect(find.text('Etusivu'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Oletko varma että haluat lähettää hätäilmoituksen?'), findsOneWidget);
        if (i==0) {
          final Finder cancelEmergencyAction = find.text('Peruuta');
          await tester.tap(cancelEmergencyAction);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
        else {
          final Finder makeEmergencyAction = find.text('Olen varma');
          await tester.tap(makeEmergencyAction);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }}
      expect(find.text('Lähetetään hätäilmoitusta'), findsOneWidget);
      // TODO: make tests for Voice message and Video when they are available.
      final Finder endBroadcast = find.text('Lopeta lähetys');
      await tester.tap(endBroadcast);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      /*// Test New report button on front page, fill in information and send the report.
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
      */});
  });
}