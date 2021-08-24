import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:frederic/admin_panel/backend/admin_backend.dart';
import 'package:frederic/admin_panel/backend/admin_icon_manager.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/frederic_admin_panel.dart';
import 'package:frederic/frederic_main_app.dart';
import 'package:frederic/screens/splash_screen.dart';
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

void main() {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(Phoenix(
    child: Frederic(),
  ));
}

class Frederic extends StatelessWidget {
  Frederic({Key? key}) : super(key: key);

  final SplashScreen splashScreen = SplashScreen();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

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
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
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
        home: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return FredericMainApp();
            }

            if (getIt.isRegistered<AdminBackend>())
              getIt.unregister<AdminBackend>();
            getIt.registerSingleton<AdminBackend>(AdminBackend());
            return BlocProvider<AdminIconManager>.value(
                value: AdminBackend.instance.iconManager,
                child: FredericAdminPanel());
          },
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
