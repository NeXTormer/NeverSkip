import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frederic/routing/route_generator.dart';
import 'package:frederic/screens/screens.dart';

class Frederic extends StatelessWidget {
  const Frederic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> app = Firebase.initializeApp();

    return FutureBuilder(
        future: app,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorScreen(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _startApp();
          }
          return _loadingScreen();
        });
  }

  Widget _startApp() {
    return MaterialApp(
      title: 'Frederic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[400],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: LoginScreen(),
    );
  }

  Widget _loadingScreen() {
    print("Loading screen....");
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

void main() {
  runApp(Frederic());
}
