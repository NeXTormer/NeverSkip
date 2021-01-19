import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper(
      {Key key, @required this.homePage, @required this.loginPage})
      : super(key: key);

  final Widget homePage;
  final Widget loginPage;

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return homePage;
    } else {
      return loginPage;
    }
  }
}
