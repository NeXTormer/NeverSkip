import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/FredericTextField.dart';

import 'file:///C:/Dev/Projects/frederic/lib/widgets/standard_elements/FredericButton.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool login = false;
  bool termsandconditions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 100),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(login ? widget.title : widget.titleSignup,
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3E4FD8)))),
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
                          Expanded(flex: 50, child: Container()),
                          if (!login)
                            FredericTextField('Name', icon: ExtraIcons.person),
                          if (!login) SizedBox(height: 10),
                          FredericTextField('E-Mail', icon: ExtraIcons.mail),
                          SizedBox(height: 10),
                          FredericTextField(
                            'Password',
                            icon: ExtraIcons.lock,
                            isPasswordField: true,
                          ),
                          if (!login) SizedBox(height: 10),
                          if (!login)
                            FredericTextField('Confirm password',
                                isPasswordField: true, icon: ExtraIcons.lock),
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
                                  Text('Terms & Conditions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                          color: const Color(0xFF2F2E41))),
                                  Text(' of this app.',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: const Color(0xFF2F2E41)))
                                ],
                              ),
                            ),
                          SizedBox(height: 40),
                          FredericButton(login ? 'Log In' : 'Sign Up'),
                          Expanded(flex: 50, child: Container()),
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
                                onTap: () => setState(() => login = !login),
                                child: Text(
                                  login ? 'Sign Up' : 'Log In',
                                  style: TextStyle(
                                      color: Color(0xFF3E4FD8),
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

  Future<void> showLoginError(String text) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login error'),
          content: Text(text ?? ''),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loginButtonHandler() {
    if (_formKey.currentState.validate()) {
      FredericBackend.instance()
          .authService
          .signIn(emailController.text.trim(), passwordController.text.trim())
          .then((value) {
        if (value != 'success' && value != null) {
          showLoginError(value);
        }
      });
    }
  }

  void signUpButtonHandler() {
    if (_formKey.currentState.validate()) {
      if (passwordController.text.trim() ==
          passwordConfirmationController.text.trim()) {
        FredericBackend.instance()
            .authService
            .signUp(emailController.text.trim(), passwordController.text.trim())
            .then((value) {
          if (value != 'success' && value != null) {
            showLoginError(value);
          }
        });
      } else {
        showLoginError('The passwords do not match');
      }
    }
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your E-Mail address';
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  String _validateConfirmationPassword(String value) {
    print('$value == ${passwordController.text}');
    if (value != passwordController.text) {
      return 'Password does not match';
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
