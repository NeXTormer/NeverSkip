import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frederic/backend/authentication_wrapper.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/bottom_navigation_screen.dart';
import 'package:frederic/providers/activity.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/providers/progress_graph.dart';
import 'package:frederic/providers/workout_edit.dart';
import 'package:frederic/routing/route_generator.dart';
import 'package:frederic/screens/screens.dart';
import 'package:provider/provider.dart';

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
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: AuthenticationWrapper(
          homePage: BottomNavigationScreen([
            FredericScreen(
                screen: HomeScreen(), icon: Icons.home_outlined, label: 'Home'),
            FredericScreen(
                screen: ActivityScreen(),
                icon: Icons.accessible_forward_outlined,
                label: 'Activities'),
            FredericScreen(
                screen: CalendarScreen(),
                icon: Icons.calendar_today_outlined,
                label: 'Calendar'),
            FredericScreen(
                screen: WorkoutOverviewScreen(),
                icon: Icons.work_outline,
                label: 'WO overview'),
          ]),
          loginPage: LoginScreen(),
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
          EditWorkoutScreen.routeName: (ctx) => EditWorkoutScreen(),
          ActivityScreen.routeName: (ctx) => ActivityScreen(),
          WorkoutOverviewScreen.routeName: (ctx) => WorkoutOverviewScreen(),
          CalendarScreen.routeName: (ctx) => CalendarScreen(),
        },
      ),
    );
  }
}
