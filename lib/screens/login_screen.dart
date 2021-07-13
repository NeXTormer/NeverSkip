import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  final String title = 'Welcome Back';
  final String titleSignup = 'Create a new account';
  final String subtitleSignup =
      'Sign up and create an account so that you can remain healthy by following your daily goals and plans.';

  final String termsAndContidionsURL = 'https://hawkford.io/';

  final String subtitle =
      'Sign in and continue so that you can remain healthy by following your daily goals and plans.';

  final RegExp emailValidator = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool login = false;
  bool termsandconditions = false;
  bool hasError = false;
  String errorText = '';

  StreamSubscription<FredericUser>? streamSubscription;

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
    double screenheight = MediaQuery.of(context).size.height;
    bool smallscreen = screenheight < 700;
    bool medscreen = screenheight < 800;
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: screenheight,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          height: smallscreen
                              ? 50
                              : medscreen
                                  ? 40
                                  : 80),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(login ? widget.title : widget.titleSignup,
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w600,
                                  color: kMainColor))),
                      SizedBox(height: 8),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              login ? widget.subtitle : widget.subtitleSignup,
                              style: TextStyle(
                                  fontSize: 12,
                                  height: 1.6,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0x993A3A3A)))),
                      SizedBox(height: 40),
                      if (!smallscreen)
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
                          if (!smallscreen)
                            Expanded(flex: 50, child: Container()),
                          //SizedBox(height: 50),
                          if (!login)
                            FredericTextField(
                              'Name',
                              icon: ExtraIcons.person,
                              controller: nameController,
                            ),
                          if (!login) SizedBox(height: 10),
                          FredericTextField('E-Mail',
                              icon: ExtraIcons.mail,
                              controller: emailController),
                          SizedBox(height: 10),
                          FredericTextField(
                            'Password',
                            icon: ExtraIcons.lock,
                            isPasswordField: true,
                            controller: passwordController,
                          ),
                          if (!login) SizedBox(height: 10),
                          if (!login)
                            FredericTextField('Confirm password',
                                isPasswordField: true,
                                icon: ExtraIcons.lock,
                                controller: passwordConfirmationController),
                          SizedBox(height: 16),
                          if (login)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF2F2E41)),
                              ),
                            ),
                          if (!login)
                            GestureDetector(
                              onTap: () => setState(() =>
                                  termsandconditions = !termsandconditions),
                              onLongPress: () =>
                                  print('Show Terms and Conditions'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  buildCheckBox(),
                                  SizedBox(width: 6),
                                  Text('I agree to the ',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: const Color(0xFF2F2E41))),
                                  GestureDetector(
                                    onTap: () {
                                      launch(widget.termsAndContidionsURL);
                                    },
                                    child: Text('Terms & Conditions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color: const Color(0xFF2F2E41))),
                                  ),
                                  Text(' of this app.',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: const Color(0xFF2F2E41)))
                                ],
                              ),
                            ),
                          SizedBox(height: 12),
                          if (hasError)
                            Align(
                              alignment: Alignment.center,
                              child: Text(errorText,
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 14)),
                            ),
                          SizedBox(height: 12),
                          FredericButton(
                            login ? 'Log In' : 'Sign Up',
                            onPressed: buttonHandler,
                          ),
                          Expanded(flex: 50, child: Container()),
                          //SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                login
                                    ? 'Don\'t have an account? '
                                    : 'Already have an account? ',
                                style: TextStyle(
                                    color: Color(0xFF2F2E41),
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
                                      color: kMainColor,
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

  Widget buildCheckBox() {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFFB8B8B8)),
          color: Colors.white),
      child: termsandconditions
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

    if (login) {
      if (email.isEmpty || password.isEmpty) {
        errorText = 'Please enter your email and password.';
        setState(() {
          hasError = true;
        });
        return;
      }
      setState(() {
        hasError = false;
      });
      FredericBackend.instance.userManager
          .add(FredericLoginEvent(email, password));
    } else {
      if (email.isEmpty ||
          password.isEmpty ||
          passwordConfirm.isEmpty ||
          name.isEmpty) {
        errorText = 'Please fill out all fields.';
        setState(() {
          hasError = true;
        });
        return;
      }

      if (!widget.emailValidator.hasMatch(email)) {
        errorText = 'Please enter a valid email.';
        setState(() {
          hasError = true;
        });
        return;
      }

      if (password != passwordConfirm) {
        errorText = 'The passwords do not match.';
        setState(() {
          hasError = true;
        });
        return;
      }

      if (!termsandconditions) {
        errorText = 'You need to accept the Terms & Conditions to use the app.';
        setState(() {
          hasError = true;
        });
        return;
      }

      if (hasError) {
        setState(() {
          hasError = false;
        });
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
    streamSubscription?.cancel();
  }
}
