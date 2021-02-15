import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/authentication_wrapper.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/providers/activity.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/providers/progress_graph.dart';
import 'package:frederic/providers/workout_edit.dart';
import 'package:frederic/routing/route_generator.dart';
import 'package:frederic/screens/activity_screen.dart';
import 'package:frederic/screens/add_graph_screen.dart';
import 'package:frederic/screens/calendar_screen.dart';
import 'package:frederic/screens/calender_screen.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/screens/new_calendar_screen.dart';
import 'package:frederic/screens/new_new_calendar_screen.dart';
import 'package:frederic/screens/new_new_new_calendar_screen.dart';
import 'package:frederic/screens/profile_screen_2.dart';
import 'package:frederic/screens/workout_overview_screen.dart';
import 'package:frederic/test_screens/all_activities_screen.dart';
import 'package:frederic/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

class FredericApp extends StatelessWidget {
  const FredericApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        Provider<FredericBackend>(
          create: (_) => FredericBackend(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FredericBackend>().authService.authStateChanges,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Goals(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProgressGraph(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Activity(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WorkoutEdit(),
        )
      ],
      child: MaterialApp(
        showPerformanceOverlay: false,
        title: 'Frederic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white, // Colors.red[400],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: AuthenticationWrapper(
          homePage: NewNewNewCalendarScreen(),
          loginPage: ProfileScreen2(),
        ),
        localizationsDelegates: const <
            LocalizationsDelegate<MaterialLocalizations>>[
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const <Locale>[
          const Locale('en', ''),
          const Locale('de', ''),
        ],
        routes: {
          AddGraphScreen.routeName: (ctx) => AddGraphScreen(),
          ProfileScreen2.routeName: (ctx) => ProfileScreen2(),
          CalenderScreen.routeName: (ctx) => CalenderScreen(),
          EditWorkoutScreen.routeName: (ctx) => EditWorkoutScreen(),
          ActivityScreen.routeName: (ctx) => ActivityScreen(),
          WorkoutOverviewScreen.routeName: (ctx) => WorkoutOverviewScreen(),
          NewNewNewCalendarScreen.routeName: (ctx) => NewNewNewCalendarScreen(),
        },
      ),
    );
  }
}
