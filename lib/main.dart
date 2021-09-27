import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/admin_panel/backend/admin_backend.dart';
import 'package:frederic/admin_panel/backend/admin_icon_manager.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/frederic_admin_panel.dart';
import 'package:frederic/frederic_main_app.dart';
import 'package:frederic/theme/frederic_theme.dart';
import 'package:get_it/get_it.dart';

//FirebaseAnalytics analytics = FirebaseAnalytics();
final getIt = GetIt.instance;

// const Color theme.mainColor = const Color(0xFF3E4FD8);
// const Color kAccentColor = const Color(0xFF4791FF);
// const Color theme.mainColor = const Color(0xFFD8903E);
// const Color kAccentColor = const Color(0xFFFFEA47);
// const Color theme.mainColorLight = const Color(0x1AD8903E);
// const Color kAccentColorLight = const Color(0xFFFFEA47);
// const Color kDividerColor = const Color(0xFFC9C9C9);
// const Color theme.backgroundColor = Colors.white;
// const Color theme.mainColorLight = const Color(0x1A3E4FD8);
// const Color kAccentColorLight = const Color(0xFFF4F7FE);
// const Color theme.positiveColor = const Color(0xFF1CBB3F);
// const Color theme.positiveColorLight = const Color(0x1A1CBB3F);
// const Color theme.greyColor = const Color(0xFFC4C4C4);
// const Color kCalendarDisabledColor = const Color(0x66A5A5A5);
//
// const Color theme.textColor = const Color(0xFF272727);
// const Color kBlack54Color = Colors.black54;
// const Color kBrightTextColor = Colors.white;
// const Color kCardBorderColor = const Color(0xFFE2E2E2);

FredericColorTheme _colorTheme = FredericColorTheme.blueDark();
FredericColorTheme get theme => _colorTheme;

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: '');
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  runApp(FredericBase());
}

class FredericBase extends StatefulWidget {
  FredericBase({Key? key}) : super(key: key);

  @override
  _FredericBaseState createState() => _FredericBaseState();

  static void forceFullRestart(BuildContext context) {
    context.findAncestorStateOfType<_FredericBaseState>()!.forceRestart();
  }

  static void setColorTheme(BuildContext context, FredericColorTheme theme) {
    _colorTheme = theme;
    context.findAncestorStateOfType<_FredericBaseState>()!.forceRestart();
  }
}

class _FredericBaseState extends State<FredericBase> {
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    getIt.registerSingleton<FredericBackend>(FredericBackend());

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
        ],
        child: MaterialApp(
          // navigatorObservers: [
          //   FirebaseAnalyticsObserver(analytics: analytics),
          // ],
          showPerformanceOverlay: false,
          title: 'Frederic',
          theme: ThemeData(
              primaryColor: theme.mainColor,
              accentColor: theme.accentColor,
              brightness: theme.isBright ? Brightness.light : Brightness.dark,
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
      ),
    );
  }

  void forceRestart() {
    setState(() {
      _key = UniqueKey();
    });
  }

  void forceRebuild() {
    setState(() {});
  }
}
