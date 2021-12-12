import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/main.dart' as app;
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'robots/login_robot.dart';
import 'robots/navigation_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.signOut();
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  group('workouts', () {
    int random = Random.secure().nextInt(4096);
    final loginRobot = LoginRobot(random);
    final navRobot = NavigationRobot();

    testWidgets('signup', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loginRobot.signUp(tester);
    });

    testWidgets('create-workout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await navRobot.gotoWorkoutScreen(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await navRobot.enterTexts(
          tester, ['Werner Workout', 'Werner Workout Description'], 1);
      await tester.tap(find.byType(FredericButton));
      await tester.pumpAndSettle();
    });

    testWidgets('open-workout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await navRobot.gotoWorkoutScreen(tester);

      final workout = find.text('Werner Workout');

      await tester.tap(workout);

      await tester.pumpAndSettle();

      expect(find.text('Werner Workout'), findsOneWidget);
    });

    testWidgets('create-and-open-workout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await navRobot.gotoWorkoutScreen(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await navRobot.enterTexts(
          tester, ['Peter Workout', 'Peter Workout Description'], 1);
      await tester.tap(find.byType(FredericButton));
      await tester.pumpAndSettle();

      final workout = find.text('Peter Workout');

      await tester.tap(workout);

      await tester.pumpAndSettle();

      expect(find.text('Peter Workout'), findsOneWidget);
    });

    if (false)
      testWidgets('edit-workout', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        await navRobot.gotoWorkoutScreen(tester);

        final workout = find.text('Peter Workout');

        await tester.tap(workout);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Icon).first);
        await tester.pumpAndSettle();

        await navRobot.enterTexts(
            tester, ['Herbert Workout', 'Herbert Workout Description'], 0);

        await tester.tap(find.text('Save').first);

        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();

        //TODO: to one screen back

        expect(find.text('Herbert Workout'), findsOneWidget);
      });

    testWidgets('delete-workout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await navRobot.gotoWorkoutScreen(tester);

      var workout = find.text('Peter Workout');

      await tester.tap(workout);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Icon).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));

      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      workout = find.text('Werner Workout');

      await tester.tap(workout);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Icon).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));

      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.text('Herbert Workout'), findsNothing);
      expect(find.text('Peter Workout'), findsNothing);
      expect(find.text('Werner Workout'), findsNothing);
    });

    testWidgets('delete-account', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loginRobot.delete(tester);
    });
  });
}
