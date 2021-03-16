import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/login_signup/login_button.dart';
import 'package:frederic/widgets/login_signup/login_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.9],
                      colors: kIconGradient,
                    )),
                  ),
                  Container(
                    child: Column(children: [
                      // SizedBox(height: 80),
                      Expanded(child: Container()),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 50),
                        child: Text("Frederic",
                            style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 56,
                                    letterSpacing: 1.4))),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 50),
                        child: Text("Your personal fitness coach",
                            style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 1.4))),
                      ),
                      SizedBox(height: 12),
                      LoginTextField(
                        validator: _validateEmail,
                        controller: emailController,
                        titleText: 'E-Mail',
                        hintText: ' Enter your E-Mail address',
                        iconData: Icons.email_outlined,
                      ),
                      SizedBox(height: 25),
                      LoginTextField(
                        validator: _validatePassword,
                        controller: passwordController,
                        titleText: 'Password',
                        hintText: ' Enter your password',
                        obscureText: true,
                        iconData: Icons.vpn_key_outlined,
                      ),
                      SizedBox(height: 24),
                      LoginButton(
                          text: 'Log in', onPressed: loginButtonHandler),
                      Expanded(flex: 6, child: Container()),
                      Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Center(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Text("Sign up",
                                    style: GoogleFonts.varelaRound(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            letterSpacing: 1.6))),
                              ),
                            ),
                          )),
                      Expanded(child: Container())
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ));
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
