import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'robots/login_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signOut();
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  group('email-auth', () {
    int random = Random.secure().nextInt(4096);
    final loginRobot = LoginRobot(random);

    testWidgets('signup-and-logout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loginRobot.signUp(tester);
      await loginRobot.logOut(tester);
    });

    testWidgets('login-and-delete', (WidgetTester tester) async {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      app.main();
      await tester.pumpAndSettle();
      await loginRobot.login(tester);
      await loginRobot.delete(tester);
    });
  });
}
