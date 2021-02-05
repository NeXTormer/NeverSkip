import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper(
      {Key key, @required this.homePage, @required this.loginPage})
      : super(key: key);

  final Widget homePage;
  final Widget loginPage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.uid != null) {
          // if the user logged in load the userdata from firestore:
          FredericBackend.of(context).currentUser =
              FredericUser(snapshot.data.uid);
          return FutureBuilder(
              future: FredericBackend.of(context).loadCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return homePage;
                } else {
                  return Scaffold(
                    body: Center(
                      child: Text('User is logged in but not in DB'),
                    ),
                  );
                }
              });
        } else {
          return loginPage;
        }
      },
    );
  }
}
