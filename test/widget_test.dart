// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:poliisiauto/src/app.dart';

void main() {
  testWidgets('SOS button smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Poliisiauto());

    // Verify that the starting page has SOS -widget
    expect(find.text('SOS'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the 'SOS' icon and trigger a frame.
    await tester.tap(find.text('SOS'));
    expect(find.text('Klikkaa painiketta uudelleen'), findsOneWidget);
    await tester.tap(find.text('SOS'));
    // await tester.pump();

    /*// Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('SOS'), findsOneWidget);*/
  });
}
