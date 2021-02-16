import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/screens.dart';
import 'package:provider/provider.dart';

class Frederic extends StatelessWidget {
  Frederic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return FutureBuilder(
        future: app,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorScreen(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _loadApp();
          }
          return _loadingScreen();
        });
  }

  Widget _loadApp() {
    return MultiProvider(
      providers: [
        Provider<FredericBackend>(
          create: (_) => FredericBackend(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FredericBackend>().authService.authStateChanges,
        ),
      ],
      child: MaterialApp(
        showPerformanceOverlay: false,
        title: 'Frederic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(
          homePage: BottomNavigationScreen(
            [
              FredericScreen(
                  screen: HomeScreen(),
                  icon: Icons.home_outlined,
                  label: 'Home'),
              FredericScreen(
                  screen: CalendarScreen(),
                  icon: Icons.calendar_today_outlined,
                  label: 'Calendar'),
              FredericScreen(
                  screen: ActivityScreen(),
                  icon: Icons.accessible_forward_outlined,
                  label: 'Exercises'),
              FredericScreen(
                  screen: ListWorkoutsScreen(),
                  icon: Icons.work_outline,
                  label: 'WO overview'),
            ],
          ),
          loginPage: LoginScreen(),
        ),
      ),
    );
  }

  Widget _loadingScreen() {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: CircularProgressIndicator(),
    )));
  }

  Widget _errorScreen(Object error) {
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

final Future<FirebaseApp> app = Firebase.initializeApp();

void main() async {
  runApp(Frederic());
}
