import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/splash_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  AuthenticationWrapper(
      {Key key,
      @required this.homePage,
      @required this.loginPage,
      @required this.splashScreen})
      : super(key: key);

  final Widget homePage;
  final Widget loginPage;
  final SplashScreen splashScreen;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.uid != null) {
            FredericBackend.instance().logIn(snapshot.data.uid);
            return FutureBuilder(
                future: FredericBackend.instance().loadCurrentUser(),
                builder: (context, snapshot) {
                  FredericBackend.instance().loadData();
                  if (snapshot.hasData) {
                    return homePage;
                  } else {
                    return splashScreen;
                  }
                });
          }
          return loginPage;
        } else {
          return loginPage;
        }
      },
    );
  }
}
