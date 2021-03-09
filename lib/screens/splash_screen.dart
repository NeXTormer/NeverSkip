import 'package:flutter/material.dart';
import 'package:frederic/widgets/frederic_circular_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.onComplete});
  final Function onComplete;

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
              increment: 0.06,
            ),
          ),
          backgroundColor: Colors.white),
    );
  }

  void handleCompletion() {
    widget.onComplete();
  }
}
