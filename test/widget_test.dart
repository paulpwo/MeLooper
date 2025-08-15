// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:se_loop/main.dart';

void main() {
  testWidgets('MeLooper app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MeLooperApp());

    // Verify that our app shows the title
    expect(find.text('MeLooper'), findsOneWidget);

    // Verify that the pads are displayed
    expect(find.text('UNDERGROUND'), findsOneWidget);
    expect(find.text('MY UNDERGROUND'), findsOneWidget);

    // Verify that MIDI configuration is shown
    expect(find.text('MIDI Configuration'), findsOneWidget);
  });
}
