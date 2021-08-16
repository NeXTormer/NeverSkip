import 'package:flutter/material.dart';
import 'package:frederic/screens/bottom_navigation_screen.dart';
import 'package:frederic/screens/splash_screen.dart';

import 'backend/authentication/authentication_wrapper.dart';
import 'misc/ExtraIcons.dart';
import 'screens/screens.dart';

class FredericMainApp extends StatelessWidget {
  FredericMainApp({Key? key}) : super(key: key);

  final SplashScreen splashScreen = SplashScreen(
    onComplete: () {
      //print('complete');
      //xFinishedLoading = true;
    },
  );

  @override
  Widget build(BuildContext context) {
    return AuthenticationWrapper(
      homePage: BottomNavigationScreen(
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
            screen: ActivityListScreen(),
            icon: ExtraIcons.dumbbell,
            label: 'Exercises',
          ),
          FredericScreen(
            screen: WorkoutListScreen(),
            icon: ExtraIcons.statistics,
            label: 'Workouts',
          ),
        ],
      ),
      loginPage: LoginScreen(),
      splashScreen: splashScreen,
    );
  }
}
