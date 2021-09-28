import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/sign_in_with_google_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  final String title = 'Welcome Back';
  final String titleSignup = 'Create a new account';
  final String subtitleSignup =
      'Sign up and create an account so that you can remain healthy by following your daily goals and plans.';

  final String subtitle =
      'Sign in and continue so that you can remain healthy by following your daily goals and plans.';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool login = false;

  StreamSubscription<FredericUser>? streamSubscription;

  bool hasError = false;
  String errorText = '';

  @override
  void initState() {
    streamSubscription =
        FredericBackend.instance.userManager.stream.listen((user) {
      if (user.statusMessage != '') {
        setState(() {
          hasError = true;
          errorText = user.statusMessage;
        });
      }
      if (user.statusMessage == '' && !user.authenticated) {
        setState(() {
          hasError = false;
          errorText = '';
        });
      }
    });
    SharedPreferences.getInstance().then((value) {
      if (value.getBool('wasLoggedIn') ?? false) {
        setState(() {
          login = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool smallScreen = screenHeight < 700;
    bool medScreen = screenHeight < 800;
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: screenHeight,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          height: smallScreen
                              ? 50
                              : medScreen
                                  ? 40
                                  : 80),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(login ? widget.title : widget.titleSignup,
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w600,
                                  color: theme.mainColorInText))),
                      SizedBox(height: 8),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            child: Text(
                                login ? widget.subtitle : widget.subtitleSignup,
                                key: ValueKey<String>(login
                                    ? widget.subtitle
                                    : widget.subtitleSignup),
                                style: TextStyle(
                                    fontSize: 12,
                                    height: 1.6,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textColor)),
                          )),
                      SizedBox(height: 40),
                      if (!smallScreen)
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26),
                            child: Image(
                                colorBlendMode: BlendMode.screen,
                                fit: BoxFit.scaleDown,
                                image: AssetImage(
                                    'assets/images/login_illustration.png'))),
                      //SizedBox(height: 80),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          _LoginByEmailButton(
                            login: login,
                            onError: (error) {
                              if (error == null) {
                                setState(() {
                                  hasError = false;
                                });
                              } else {
                                setState(() {
                                  errorText = error;
                                  hasError = true;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 12),
                          SignInWithGoogleButton(
                            signUp: !login,
                          ),
                          SizedBox(height: 12),
                          if (hasError)
                            Align(
                              alignment: Alignment.center,
                              child: Text(errorText,
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 14)),
                            ),
                          Expanded(flex: 50, child: Container()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                login
                                    ? 'Don\'t have an account? '
                                    : 'Already have an account? ',
                                style: TextStyle(
                                    color: theme.textColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  login = !login;
                                  hasError = false;
                                }),
                                child: Text(
                                  login ? 'Sign Up' : 'Log In',
                                  style: TextStyle(
                                      color: theme.mainColorInText,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();

    streamSubscription?.cancel();
  }
}

class _LoginByEmailButton extends StatefulWidget {
  _LoginByEmailButton(
      {this.login = true,
      this.expanded = false,
      required this.onError,
      Key? key})
      : super(key: key);

  final bool login;
  final bool expanded;

  final void Function(String? error) onError;

  final RegExp emailValidator = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  final String termsAndContidionsURL = 'https://hawkford.io/';

  @override
  _LoginByEmailButtonState createState() => _LoginByEmailButtonState();
}

class _LoginByEmailButtonState extends State<_LoginByEmailButton> {
  bool expanded = false;
  bool acceptedTermsAndConditions = false;
  String buttonText = '';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    expanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buttonText = expanded
        ? (widget.login ? 'Log in' : 'Sign up')
        : (widget.login ? 'Log in with E-Mail' : 'Sign up with E-Mail');
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: expanded ? (widget.login ? 144 : 254) : 0,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              if (!widget.login)
                FredericTextField(
                  'Name',
                  icon: ExtraIcons.person,
                  controller: nameController,
                ),
              if (!widget.login) SizedBox(height: 10),
              FredericTextField('E-Mail',
                  icon: ExtraIcons.mail, controller: emailController),
              SizedBox(height: 10),
              FredericTextField(
                'Password',
                icon: ExtraIcons.lock,
                isPasswordField: true,
                controller: passwordController,
              ),
              if (!widget.login) SizedBox(height: 10),
              if (!widget.login)
                FredericTextField('Confirm password',
                    isPasswordField: true,
                    icon: ExtraIcons.lock,
                    controller: passwordConfirmationController),
              SizedBox(height: 16),
              if (widget.login)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: theme.textColor),
                  ),
                ),
              if (!widget.login)
                GestureDetector(
                  onTap: () => setState(() =>
                      acceptedTermsAndConditions = !acceptedTermsAndConditions),
                  onLongPress: () => print('Show Terms and Conditions'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildCheckBox(),
                      SizedBox(width: 6),
                      Text('I agree to the ',
                          style:
                              TextStyle(fontSize: 11, color: theme.textColor)),
                      GestureDetector(
                        onTap: () {
                          launch(widget.termsAndContidionsURL);
                        },
                        child: Text('Terms & Conditions',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: theme.textColor)),
                      ),
                      Text(' of this app.',
                          style:
                              TextStyle(fontSize: 11, color: theme.textColor))
                    ],
                  ),
                ),
              SizedBox(height: 12),
            ]),
          ),
        ),
        FredericButton(
          buttonText,
          onPressed: () {
            if (!expanded) {
              setState(() {
                expanded = true;
              });
            } else {
              buttonHandler();
            }
          },
        ),
      ],
    );
  }

  Widget buildCheckBox() {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFFB8B8B8)),
          color: Colors.white),
      child: acceptedTermsAndConditions
          ? Icon(
              Icons.check,
              size: 12,
              color: const Color(0xFF5C5C5C),
            )
          : null,
    );
  }

  void buttonHandler() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String passwordConfirm = passwordConfirmationController.text.trim();

    if (widget.login) {
      if (email.isEmpty || password.isEmpty) {
        widget.onError('Please enter your email and password.');
        return;
      }
      widget.onError(null);
      FredericBackend.instance.userManager
          .add(FredericLoginEvent(email, password));
    } else {
      if (email.isEmpty ||
          password.isEmpty ||
          passwordConfirm.isEmpty ||
          name.isEmpty) {
        widget.onError('Please fill out all fields');

        return;
      }

      if (!widget.emailValidator.hasMatch(email)) {
        widget.onError('Please enter a valid email.');

        return;
      }

      if (password != passwordConfirm) {
        widget.onError('The passwords do not match.');

        return;
      }

      if (!acceptedTermsAndConditions) {
        widget.onError(
            'You need to accept the Terms & Conditions to use the app.');

        return;
      }

      FredericBackend.instance.userManager.add(FredericSignupEvent(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    passwordConfirmationController.dispose();
  }
}
