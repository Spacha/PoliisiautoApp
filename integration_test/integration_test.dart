import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:poliisiauto/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  // tester.pumpAndSettle has Duration (1s) set for tester friendliness, it is
  // then easier to follow. Duration is only necessary when the app is launched
  // and we need to wait for the splash screen to close (set to 5s). Another option
  // is to make a splash screen wait.
  group('end-to-end test', () {
    testWidgets('Forgot password', (tester) async {app.main();
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
  
    testWidgets('Home page with test -user.', (tester) async {app.main();
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
      final Finder logOutButton = find.text('Kirjaudu ulos');
      await tester.tap(logOutButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Kirjaudu sisään'), findsOneWidget);
    });

    testWidgets('Sidebar with test -user.', (tester) async {app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Kirjaudu sisään'), findsOneWidget);

      // Try logging in with test credentials.
      // final Finder debugUserButton = find.byKey(const ValueKey("debug teacher"));
      final Finder debugUserButton = find.byKey(const ValueKey("debug student"));
      await tester.tap(debugUserButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      /* USE THESE LINES FOR LOG IN ONCE DEBUG USERS ARE REMOVED FROM THE LOG IN -PAGE:
      await tester.enterText(find.byKey(const ValueKey("e-mail")), 'olli.o@esimerkki.fi');
      await tester.enterText(find.byKey(const ValueKey("password")), 'salasana');
      */
      final Finder loginButton2 = find.text('Kirjaudu');
      await tester.tap(loginButton2);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // Open all pages from all pages using side bar.
      final Finder drawer = find.byTooltip('Open navigation menu');

      const iconList = [Icons.house_outlined, Icons.speaker_notes_outlined,
                        Icons.help_outline, Icons.settings, Icons.info_outlined];
      const screenList = ["Etusivu", "Ilmoitukset", "Apua", 
                          "Asetukset", "Tietoa sovelluksesta"];
      for (var i=0; i<iconList.length; i++) {
        for (var j=0; j<iconList.length; j++) {
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
      }
      expect(drawer, findsWidgets);
      await tester.tap(drawer);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final Finder logOutButton = find.byIcon(Icons.logout_outlined);
      await tester.tap(logOutButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Kirjaudu sisään'), findsWidgets);
    });
    testWidgets('New report page', (tester) async {app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Kirjaudu sisään'), findsOneWidget);

      // Try logging in with test credentials.
      final Finder debugStudentButton = find.byKey(const ValueKey("debug student"));
      await tester.tap(debugStudentButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      /* USE THESE LINES FOR LOG IN ONCE DEBUG USERS ARE REMOVED FROM THE LOG IN -PAGE:
      await tester.enterText(find.byKey(const ValueKey("e-mail")), 'olli.o@esimerkki.fi');
      await tester.enterText(find.byKey(const ValueKey("password")), 'salasana');
      */
      final Finder loginButton2 = find.text('Kirjaudu');
      await tester.tap(loginButton2);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Go to reports -page via sidebar
      final Finder drawer = find.byTooltip('Open navigation menu');
      expect(drawer, findsWidgets);
      await tester.tap(drawer);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final Finder goToIcon = find.byIcon(Icons.speaker_notes_outlined);
      await tester.tap(goToIcon);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Go to new report -page via floating button
      for (var i=0; i<2; i++) {
        expect(find.text('Ilmoitukset'), findsWidgets);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        if (i==0) {
          expect(find.byTooltip('Back'), findsOneWidget);
          await tester.tap(find.byTooltip('Back'));
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
        else {
          await tester.enterText(find.byKey(const ValueKey("Description")), 
          "Ville löi Elliä ruokatunnilla.");
          await tester.enterText(find.byKey(const ValueKey("Bully")), 
          'Ville Vitosluokkalainen');

          final bulliedCheckboxFinder = find.byKey(const ValueKey("BulliedCheckbox"));
          var bulliedCheckbox = tester.firstWidget(bulliedCheckboxFinder) as CheckboxListTile;
          expect(bulliedCheckbox.value, false);
          // TODO: make check that the text input is not possible when Checkbox is unchecked.
          await tester.tap(bulliedCheckboxFinder);
          await tester.pumpAndSettle();
          /*await tester.enterText(find.byKey(const ValueKey("Bullied")),
          'Elli Eskarilainen');
          await tester.pumpAndSettle();*/
          //expect(find.text("Elli Eskarilainen"), findsOneWidget);
          final teacherDrobdownFinder = find.byKey(const ValueKey("SendTo"));
          await tester.tap(teacherDrobdownFinder);
          await tester.pumpAndSettle();
          final dropdownItem = find.text('Olli Opettaja').last;
          await tester.tap(dropdownItem);
          await tester.pumpAndSettle();
          final anonCheckboxFinder = find.byKey(const ValueKey("AnonCheckbox"));
          var anonCheckbox = tester.firstWidget(anonCheckboxFinder) as CheckboxListTile;
          expect(anonCheckbox.value, false);
          await tester.tap(anonCheckboxFinder);
          await tester.pumpAndSettle();
          // expect(anonCheckbox.value, true); does not work as expected, why?
          final sendReportButton = find.text('Lähetä');
          await tester.tap(sendReportButton);
          await tester.pumpAndSettle();
          expect(find.text("Ilmoitukset"), findsOneWidget);
          final sentReportFinder = find.textContaining("Ville löi");
          await tester.tap(sentReportFinder);
          await tester.pumpAndSettle();
          expect(find.textContaining("Ville löi"), findsOneWidget);
          await tester.pumpAndSettle(const Duration(seconds: 10));

        }}
    });
  });
}