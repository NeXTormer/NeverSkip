import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/splash_screen.dart';

class AuthenticationWrapper extends StatefulWidget {
  AuthenticationWrapper(
      {Key? key,
      required this.homePage,
      required this.loginPage,
      required this.splashScreen})
      : super(key: key);

  final Widget homePage;
  final Widget loginPage;
  final SplashScreen splashScreen;

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: FredericBackend.instance.userManager,
      child: BlocBuilder<FredericUserManager, FredericUser>(
          buildWhen: (previous, next) =>
              previous.authenticated != next.authenticated,
          builder: (context, user) {
            return user.authenticated ? widget.homePage : widget.loginPage;
          }),
    );
  }
}
