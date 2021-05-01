import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/screens.dart';
import 'package:frederic/screens/splash_screen.dart';
import 'package:frederic/widgets/profile_screen/goal/edit_goal_item.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
final Future<FirebaseApp> app = Firebase.initializeApp();
final getIt = GetIt.instance;

final Color kMainColor = Colors.lightBlue;
final Color kAccentColor = Colors.lightBlueAccent;
final Color kDarkColor = Colors.blueAccent;
final Color kTextColor = Colors.blue[800];
final Color kAppBarTextColor = Colors.white;
final List<Color> kIconGradient = [Color(0xFF18BBDF), Color(0xFF175BD5)];
final double kAppBarHeight = 0;

void main() {
  runApp(Frederic());
}

class Frederic extends StatelessWidget {
  Frederic({Key key}) : super(key: key);

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
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          primaryColor: Color(0xFF3E4FD8),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(
          homePage: BottomNavigationScreen(
            [
              FredericScreen(
                  screen: HomeScreen(),
                  icon: Icons.home_outlined,
                  label: 'Home',
                  appbar: FredericAppBar(
                      title: Text(
                    'Frederic',
                    key: ValueKey(1),
                  ))),
              FredericScreen(
                  screen: CalendarScreen(),
                  icon: Icons.calendar_today_outlined,
                  label: 'Calendar',
                  appbar: FredericAppBar(
                      title: Text('Calendar', key: ValueKey(2)))),
              FredericScreen(
                  screen: ActivityScreen(),
                  icon: Icons.accessible_forward_outlined,
                  label: 'Exercises',
                  appbar: FredericAppBar(
                      title: Text('Exercises', key: ValueKey(3)))),
              FredericScreen(
                  screen: ListWorkoutsScreen(),
                  icon: Icons.work_outline,
                  label: 'Workouts',
                  appbar: FredericAppBar(
                      title: Text('Workouts', key: ValueKey(4)))),
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

  /// On pressed show ModalBottomSheet
  ///
  /// The bottom sheet contains the [EditSlideSheet] Widget
  /// so the user can interact with the goal.
  void _handleButtonPress(BuildContext context, String id) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: EditGoalItem(null),
            ),
          ],
        );
      },
    );
  }
}
