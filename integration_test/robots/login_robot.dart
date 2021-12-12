import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

class LoginRobot {
  LoginRobot([this.randomID]) {
    if (randomID == null) randomID = Random().nextInt(4096);
  }
  int? randomID;

  Future<void> signUp(WidgetTester tester) async {
    expect(find.text('Create a new account'), findsOneWidget);

    await tester.tap(find.text('Sign up with E-Mail'));
    await tester.pumpAndSettle();

    final textFields = find.byType(FredericTextField);

    await tester.enterText(textFields.at(0), 'integration_test$randomID');
    await tester.enterText(textFields.at(1), 'itest$randomID@example.com');
    await tester.enterText(textFields.at(2), 'wernerfindenig');
    await tester.enterText(textFields.at(3), 'wernerfindenig');

    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();

    await tester.tap(find.text('I agree to the '));
    await tester.tap(find.byType(FredericButton));

    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));

    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));

    await tester.pumpAndSettle();

    expect(find.text('Personal records'), findsOneWidget);
  }

  Future<void> login(WidgetTester tester) async {
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);

    await tester.tap(find.text('Log in with E-Mail'));
    await tester.pumpAndSettle();

    final textFields = find.byType(FredericTextField);

    await tester.enterText(textFields.at(0), 'itest$randomID@example.com');
    await tester.enterText(textFields.at(1), 'wernerfindenig');

    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();

    await tester.tap(find.byType(FredericButton));

    await tester.pumpAndSettle();

    expect(find.text('Personal records'), findsOneWidget);
  }

  Future<void> logOut(WidgetTester tester) async {
    await tester.tap(find.byType(FredericContainerTransition).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('integration_test$randomID'));
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
  }

  Future<void> delete(WidgetTester tester) async {
    await tester.tap(find.byType(FredericContainerTransition).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('integration_test$randomID'));
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

    await tester.enterText(
        find.byType(FredericTextField).last, 'integrationtest');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();

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
  }
}
