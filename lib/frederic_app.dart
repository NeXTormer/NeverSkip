import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/authentication_wrapper.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/providers/activity.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/providers/progress_graph.dart';
import 'package:frederic/routing/route_generator.dart';
import 'package:frederic/deprecated/profile_screen_dev.dart';
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
          homePage: HomeScreen(),
          loginPage: LoginScreen(),
        ),
      ),
    );
  }
}
