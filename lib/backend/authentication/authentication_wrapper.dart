import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationWrapper extends StatefulWidget {
  AuthenticationWrapper(
      {Key? key,
      required this.homePage,
      required this.loginPage,
      required this.welcomePage})
      : super(key: key);

  final Widget homePage;
  final Widget loginPage;
  final Widget welcomePage;

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();

  static void rebuild(BuildContext context) {
    context.findAncestorStateOfType<_AuthenticationWrapperState>()!.rebuild();
  }
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.containsKey('show_welcome_screen') ?? true) {
              if (snapshot.data?.getBool('show_welcome_screen') ?? true) {
                snapshot.data?.setBool('show_welcome_screen', false);
                return widget.welcomePage;
              }
            } else {
              snapshot.data?.setBool('show_welcome_screen', false);
              return widget.welcomePage;
            }
          }
          return BlocBuilder<FredericUserManager, FredericUser>(
              buildWhen: (previous, next) =>
                  previous.authState != next.authState,
              builder: (context, user) {
                return user.authState == FredericAuthState.Authenticated
                    ? widget.homePage
                    : widget.loginPage;
              });
        });
  }

  void rebuild() {
    setState(() {});
  }
}
