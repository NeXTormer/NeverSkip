import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';

class AuthenticationWrapper extends StatefulWidget {
  AuthenticationWrapper({
    Key? key,
    required this.homePage,
    required this.loginPage,
  }) : super(key: key);

  final Widget homePage;
  final Widget loginPage;

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericUserManager, FredericUser>(
        buildWhen: (previous, next) =>
            previous.authenticated != next.authenticated,
        builder: (context, user) {
          return user.authenticated ? widget.homePage : widget.loginPage;
        });
  }
}
