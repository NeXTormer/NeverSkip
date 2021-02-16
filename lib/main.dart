import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frederic/frederic_app.dart';

class Frederic extends StatelessWidget {
  Frederic({Key key}) : super(key: key);
  final Future<FirebaseApp> app = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: app,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorScreen(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return FredericApp();
          }
          return _loadingScreen();
        });
  }

  Widget _loadingScreen() {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: Text("Loading...",
          style: TextStyle(fontSize: 28, color: Colors.black38)),
    )));
  }

  Widget _errorScreen(Object error) {
    print("ERROR");
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: Container(
        child: Text(
          "ERROR: ${error.toString()}",
          style: TextStyle(fontSize: 22),
        ),
      ),
    )));
  }
}

void main() async {
  runApp(Frederic());
}
