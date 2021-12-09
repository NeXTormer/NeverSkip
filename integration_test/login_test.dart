import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/main.dart' as app;
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('email-login-actions', () {
    int random = Random.secure().nextInt(4096);
    testWidgets('email-signup-logout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Create a new account'), findsOneWidget);

      await tester.tap(find.text('Sign up with E-Mail'));
      await tester.pumpAndSettle();

      final textFields = find.byType(FredericTextField);

      await tester.enterText(textFields.at(0), 'integration_test$random');
      await tester.enterText(textFields.at(1), 'itest$random@example.com');
      await tester.enterText(textFields.at(2), 'wernerfindenig');
      await tester.enterText(textFields.at(3), 'wernerfindenig');

      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      await tester.tap(find.text('I agree to the '));
      await tester.tap(find.byType(FredericButton));

      await tester.pumpAndSettle();

      expect(find.text('Personal records'), findsOneWidget);

      await tester.tap(find.byType(FredericContainerTransition).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('integration_test$random'));
      await tester.pumpAndSettle();

      final signOutButton = find.text('Sign Out');
      final listFinder = find.byType(Scrollable);

      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        signOutButton,
        500.0,
        scrollable: listFinder,
      );
      await tester.pumpAndSettle();

      await tester.tap(signOutButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      final text1 = find.text('Create a new account');
      final text2 = find.text('Welcome Back');
      int count = text1.evaluate().length;
      count += text2.evaluate().length;

      expect(count, 1);

      //await FredericBackend.instance.userManager.deleteUser(true);
    });

    testWidgets('email-login-delete-account', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);

      await tester.tap(find.text('Log in with E-Mail'));
      await tester.pumpAndSettle();

      final textFields = find.byType(FredericTextField);

      await tester.enterText(textFields.at(0), 'itest$random@example.com');
      await tester.enterText(textFields.at(1), 'wernerfindenig');

      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FredericButton));

      await tester.pumpAndSettle();

      expect(find.text('Personal records'), findsOneWidget);

      await tester.tap(find.byType(FredericContainerTransition).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('integration_test$random'));
      await tester.pumpAndSettle();

      final deleteButton = find.text('Delete Account');

      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(
        deleteButton,
        500.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byType(FredericTextField).first, 'wernerfindenig');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.scrollUntilVisible(
        find.text('Delete account forever').first,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FredericButton).first);

      await tester.pumpAndSettle();

      final text1 = find.text('Create a new account');
      final text2 = find.text('Welcome Back');
      int count = text1.evaluate().length;
      count += text2.evaluate().length;

      expect(count, 1);
    });
  });
}
