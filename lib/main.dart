import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/screens.dart';
import 'package:frederic/screens/splash_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
final Future<FirebaseApp> app = Firebase.initializeApp();
final getIt = GetIt.instance;

void main() {
  runApp(Frederic());
}

class Frederic extends StatelessWidget {
  Frederic({Key key}) : super(key: key);

  final SplashScreen splashScreen = SplashScreen(
    onComplete: () {
      //xFinishedLoading = true;
    },
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //splashScreen = SplashScreen();

    return FutureBuilder(
        future: app,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorScreen(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _loadApp();
          }
          return splashScreen;
        });
  }

  Widget _loadApp() {
    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    getIt.registerSingleton<FredericBackend>(FredericBackend());

    return MultiProvider(
      providers: [
        StreamProvider(
          create: (context) =>
              context.read<FredericBackend>().authService.authStateChanges,
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
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
          splashScreen: splashScreen,
        ),
      ),
    );
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
