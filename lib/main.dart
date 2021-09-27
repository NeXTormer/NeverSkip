import 'dart:async';
import 'dart:isolate';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:frederic/backend/analytics_service.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/screens/home_screen.dart';
import 'package:frederic/screens/screens.dart';
import 'package:frederic/screens/splash_screen.dart';
import 'package:frederic/screens/workout_list_screen.dart';
import 'package:get_it/get_it.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
final Future<FirebaseApp> app = Firebase.initializeApp();
final getIt = GetIt.instance;

const Color kMainColor = const Color(0xFF3E4FD8);
const Color kAccentColor = const Color(0xFF4791FF);
// const Color kMainColor = const Color(0xFFD8903E);
// const Color kAccentColor = const Color(0xFFFFEA47);
// const Color kMainColorLight = const Color(0x1AD8903E);
// const Color kAccentColorLight = const Color(0xFFFFEA47);
const Color kDividerColor = const Color(0xFFC9C9C9);
const Color kScaffoldBackgroundColor = Colors.white;
const Color kMainColorLight = const Color(0x1A3E4FD8);
const Color kAccentColorLight = const Color(0xFFF4F7FE);
const Color kGreenColor = const Color(0xFF1CBB3F);
const Color kGreenColorLight = const Color(0x1A1CBB3F);
const Color kGreyColor = const Color(0xFFC4C4C4);
const Color kCalendarDisabledColor = const Color(0x66A5A5A5);

const Color kTextColor = const Color(0xFF272727);
const Color kBlack54Color = Colors.black54;
const Color kBrightTextColor = Colors.white;
const Color kCardBorderColor = const Color(0xFFE2E2E2);
const List<Color> kIconGradient = [Color(0xFF18BBDF), Color(0xFF175BD5)];

const _kTestingCrashlytics = true;

void main() {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    if (_kTestingCrashlytics) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    runApp(Phoenix(
      child: Frederic(),
    ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class Frederic extends StatelessWidget {
  final SplashScreen splashScreen = SplashScreen(
    onComplete: () {
      //print('complete');
      //xFinishedLoading = true;
    },
  );

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
            return _loadApp(context);
          }
          return splashScreen;
        });
  }

  Widget _loadApp(BuildContext context) {
    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    getIt.registerSingleton<FredericBackend>(FredericBackend());
    if (getIt.isRegistered<AnalyticsService>())
      getIt.unregister<AnalyticsService>();
    getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

    //SystemChrome.setSystemUIOverlayStyle(
    //    SystemUiOverlayStyle(statusBarColor: Colors.blue));

    return MultiBlocProvider(
      providers: [
        BlocProvider<FredericUserManager>.value(
            value: FredericBackend.instance.userManager),
        BlocProvider<FredericSetManager>.value(
            value: FredericBackend.instance.setManager),
        BlocProvider<FredericActivityManager>.value(
            value: FredericBackend.instance.activityManager),
        BlocProvider<FredericWorkoutManager>.value(
            value: FredericBackend.instance.workoutManager),
        BlocProvider<FredericGoalManager>.value(
            value: FredericBackend.instance.goalManager),
      ],
      child: MaterialApp(
        navigatorObservers: [
          getIt<AnalyticsService>().getAnalyticsObserver(),
        ],
        showPerformanceOverlay: false,
        title: 'Frederic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: kMainColor,
            accentColor: kAccentColor,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            fontFamily: 'Montserrat',
            textTheme: TextTheme(
              headline1: TextStyle(
                  color: const Color(0xFF272727),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.6,
                  fontSize: 13),
            )),
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
