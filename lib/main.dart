import 'dart:async';
import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:frederic/backend/sets/frederic_set_document.dart';
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
//FredericColorTheme _theme = FredericColorTheme.fromColor(Colors.brown, true);
FredericColorTheme get theme => _colorTheme;

void main() async {
  final timeUntilRunApp = FredericProfiler.track('time until runApp()');
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // == Record all errors outside a Flutter context ==
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);

  // == Record all errors within a Flutter context ==
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp();

    // == Crashlytics & Performance ==
    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    // == Crashlytics & Performance == End ==

    // == Hive == Register Adapters ==
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1))
      Hive.registerAdapter(FredericUniversalTypeAdapter<FredericActivity>(1,
          create: (id, data) => FredericActivity.fromMap(id, data)));
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(FredericUniversalTypeAdapter<FredericWorkout>(2,
          create: (id, data) => FredericWorkout.fromMap(id, data)));
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(FredericUniversalTypeAdapter<FredericSetDocument>(3,
          create: (id, data) => FredericSetDocument.fromMap(id, data)));
    if (!Hive.isAdapterRegistered(100))
      Hive.registerAdapter(TimestampTypeAdapter()); // typeId: 100
    // == Hive == End ==

    //await Hive.deleteBoxFromDisk('Sets');

    // == Load Startup Preferences ==
    final colorThemeProfiler = FredericProfiler.track('load color theme');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Object? themeID = preferences.get('colortheme');
    if (themeID != null && themeID is int) {
      _colorTheme = FredericColorTheme.find(themeID);
    }
    colorThemeProfiler.stop();
    // == Load Startup Preferences == End ==

    // == Disable Analytics in debug mode
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    }

    timeUntilRunApp.stop();
    runApp(EasyLocalization(
        supportedLocales: [Locale('en'), Locale('de')],
        fallbackLocale: Locale('en'),
        useOnlyLangCode: true,
        path: 'assets/translations',
        child: FredericBase()));
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
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: ThemeData(
              primaryColor: theme.mainColor,
              brightness: theme.isBright ? Brightness.light : Brightness.dark,
              fontFamily: 'Montserrat',
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: theme.accentColor,
                  primary: theme.mainColor,
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
