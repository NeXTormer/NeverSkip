import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/admin_panel/backend/admin_backend.dart';
import 'package:frederic/admin_panel/backend/admin_icon_manager.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/type_adapters/frederic_universal_type_adapter.dart';
import 'package:frederic/backend/database/type_adapters/timestamp_type_adapter.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/frederic_admin_panel.dart';
import 'package:frederic/frederic_main_app.dart';
import 'package:frederic/theme/frederic_theme.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

FredericColorTheme _colorTheme = FredericColorTheme.blue();
FredericColorTheme get theme => _colorTheme;

const bool _kTestingCrashlytics = true;

void main() async {
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

  //TODO: Check this code
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    if (_kTestingCrashlytics) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // == Hive ==
    await Hive.initFlutter();
    //await Hive.deleteBoxFromDisk('workouts');
    Hive.registerAdapter(FredericUniversalTypeAdapter<FredericActivity>(1,
        create: (id, data) => FredericActivity.fromMap(id, data)));
    Hive.registerAdapter(FredericUniversalTypeAdapter<FredericWorkout>(2,
        create: (id, data) => FredericWorkout.fromMap(id, data)));
    Hive.registerAdapter(TimestampTypeAdapter()); // typeId: 100

    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

    final colorThemeProfiler = FredericProfiler.track('load color theme');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Object? themeID = preferences.get('colortheme');
    if (themeID != null && themeID is int) {
      _colorTheme = FredericColorTheme.find(themeID);
    }
    colorThemeProfiler.stop();

    runApp(FredericBase());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class FredericBase extends StatefulWidget {
  FredericBase({Key? key}) : super(key: key);

  @override
  _FredericBaseState createState() => _FredericBaseState();

  static void forceFullRestart(BuildContext context) {
    context.findAncestorStateOfType<_FredericBaseState>()!.forceRestart();
  }

  static void setColorTheme(
      BuildContext context, FredericColorTheme theme) async {
    _colorTheme = theme;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('colortheme', theme.uid);
    context.findAncestorStateOfType<_FredericBaseState>()!.forceRestart();
  }
}

class _FredericBaseState extends State<FredericBase> {
  Key? _key;

  @override
  void initState() {
    _key = UniqueKey();

    initData();
    super.initState();
  }

  void initData() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      if (kDebugMode) DeviceOrientation.landscapeLeft,
      if (kDebugMode) DeviceOrientation.landscapeRight
    ]);

    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    getIt.registerSingleton<FredericBackend>(FredericBackend());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: MultiBlocProvider(
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
          showPerformanceOverlay: false,
          title: 'NeverSkip Fitness',
          theme: ThemeData(
              primaryColor: theme.mainColor,
              brightness: theme.isBright ? Brightness.light : Brightness.dark,
              fontFamily: 'Montserrat',
              textTheme: TextTheme(
                headline1: TextStyle(
                    color: const Color(0xFF272727),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    fontSize: 13),
              ),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: theme.accentColor,
                  brightness:
                      theme.isBright ? Brightness.light : Brightness.dark)),
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
      ),
    );
  }

  void forceRestart() {
    setState(() {
      _key = UniqueKey();
      initData();
    });
  }

  void forceRebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    super.dispose();
  }
}
