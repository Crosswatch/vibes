import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_timer/main.dart';

void main() {
  testWidgets('App starts and loads workout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WorkoutTimerApp());

    // Verify that we see a loading indicator initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for the workout to load
    await tester.pumpAndSettle();

    // Verify that the app title is present
    expect(find.text('Workout Timer'), findsOneWidget);
  });
}
