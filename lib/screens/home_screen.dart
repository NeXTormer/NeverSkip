import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("findenigg");
    return Scaffold(
      body: Center(
        child: Text(
          "Frederic home screen",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
