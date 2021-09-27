import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(child: CupertinoActivityIndicator()),
          backgroundColor: theme.backgroundColor),
    );
  }
}
