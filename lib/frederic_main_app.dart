import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/welcome_screen.dart';

import 'backend/authentication/authentication_wrapper.dart';
import 'misc/ExtraIcons.dart';
import 'screens/screens.dart';

class FredericMainApp extends StatelessWidget {
  const FredericMainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthenticationWrapper(
      homePage: BottomNavigationScreen(
        [
          FredericScreen(
            screen: HomeScreen(),
            icon: ExtraIcons.person,
            label: tr('home.navbar'),
          ),
          FredericScreen(
            screen: CalendarScreen(),
            icon: ExtraIcons.calendar,
            label: tr('calendar.navbar'),
          ),
          FredericScreen(
            screen: ActivityListScreen(),
            icon: ExtraIcons.dumbbell,
            label: tr('exercises.navbar'),
          ),
          FredericScreen(
            screen: WorkoutListScreen(),
            icon: Icons.view_timeline_outlined,
            label: tr('workouts.navbar'),
          ),
        ],
      ),
      loginPage: LoginScreen(),
      welcomePage: WelcomeScreen(),
    );
  }
}
