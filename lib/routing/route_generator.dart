import 'package:flutter/material.dart';
import 'package:frederic/screens/home_screen.dart';
import 'package:frederic/screens/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final path = settings.name;

    if (path == "/") {
      return MaterialPageRoute(builder: (context) => LoginScreen());
    } else if (path == '/home') {
      return MaterialPageRoute(builder: (context) => HomeScreen());
    }
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              body: Center(
                child: Text("no route"),
              ),
            ));
  }
}
