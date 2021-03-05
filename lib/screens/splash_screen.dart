import 'package:flutter/material.dart';
import 'package:frederic/widgets/frederic_circular_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
            child: FredericCircularProgressIndicator(
              increment: 0.04,
            ),
          ),
          backgroundColor: Colors.white),
    );
  }
}
