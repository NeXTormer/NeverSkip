import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/main.dart' as app;
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('email-login-test', () {
    testWidgets('login with email and password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Create a new account'), findsOneWidget);

      await tester.tap(find.text('Sign up with E-Mail'));
      await tester.pumpAndSettle();

      // await tester.tap(find.text('Log In'));
      // await tester.pumpAndSettle();

      // expect(find.text('Forgot password?'), findsOneWidget);

      final textFields = find.byType(FredericTextField);

      await tester.enterText(textFields.at(0), 'Gunnhildr Medb Helewidis');
      await tester.enterText(textFields.at(1), 'cvbncvbntwu@ghkhgjkh.at');
      await tester.enterText(textFields.at(2), 'Helewidis');
      await tester.enterText(textFields.at(3), 'Helewidis');

      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FredericButton));

      await tester.pumpAndSettle();

      expect(find.text('Personal records'), findsOneWidget);

      await FredericBackend.instance.userManager.deleteUser(true);

      await tester.pumpAndSettle();
    });
  });
}
