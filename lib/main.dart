import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/home_screen.dart';
import 'package:frederic/screens/screens.dart';
import 'package:frederic/screens/splash_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
final Future<FirebaseApp> app = Firebase.initializeApp();
final getIt = GetIt.instance;

final Color kMainColor = const Color(0xFF3E4FD8);
final Color kAccentColor = const Color(0xFF4791FF);
final Color kMainColorLight = const Color(0x1A3E4FD8);
final Color kAccentColorLight = const Color(0xFFF4F7FE);
final Color kGreyColor = const Color(0xFFC4C4C4);

final Color kTextColor = const Color(0xFF272727);
final Color kCardBorderColor = const Color(0xFFE2E2E2);
final List<Color> kIconGradient = [Color(0xFF18BBDF), Color(0xFF175BD5)];

void main() {
  runApp(Frederic());
}

class Frederic extends StatelessWidget {
  Frederic({Key? key}) : super(key: key);

  final SplashScreen splashScreen = SplashScreen(
    onComplete: () {
      //print('complete');
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
            return _loadApp(context);
          }
          return splashScreen;
        });
  }

  Widget _loadApp(BuildContext context) {
    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    getIt.registerSingleton<FredericBackend>(FredericBackend());

    //SystemChrome.setSystemUIOverlayStyle(
    //    SystemUiOverlayStyle(statusBarColor: Colors.blue));

    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          initialData: FirebaseAuth.instance.currentUser,
          create: (context) =>
              context.read<FredericBackend>().authService!.authStateChanges,
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
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          primaryColor: Color(0xFF3E4FD8),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(
          homePage: false
              ? HomeScreen()
              : BottomNavigationScreen(
                  [
                    FredericScreen(
                      screen: HomeScreen(),
                      icon: ExtraIcons.person,
                      label: 'Home',
                    ),
                    FredericScreen(
                      screen: CalendarScreen(),
                      icon: ExtraIcons.calendar,
                      label: 'Calendar',
                    ),
                    FredericScreen(
                      screen: Container(),
                      icon: ExtraIcons.dumbbell,
                      label: 'Exercises',
                    ),
                    FredericScreen(
                      screen: ListWorkoutsScreen(),
                      icon: ExtraIcons.statistics,
                      label: 'Workouts',
                    ),
                  ],
                ),
          loginPage: LoginScreen(),
          splashScreen: splashScreen,
        ),
      ),
    );
  }

  Widget _errorScreen(Object? error) {
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
