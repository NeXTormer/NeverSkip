import 'package:flutter_test/flutter_test.dart';
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

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log in with E-Mail'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot password?'), findsOneWidget);

      await tester.enterText(
          find.byType(FredericTextField).first, 'werner@findenig.at');
      await tester.enterText(find.byType(FredericTextField).last, 'findenig');

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FredericButton));

      await tester.pumpAndSettle();

      expect(find.text('The email does not exist.'), findsOneWidget);
    });
  });
}
