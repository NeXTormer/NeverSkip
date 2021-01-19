import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication_service.dart';
import 'package:frederic/util/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
        body: Form(
      key: _formKey,
      child: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: Palette.kLoginBackgroundGradient),
          ),
          Container(
            child: Column(children: [
              SizedBox(height: 80),
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
              SizedBox(height: 40),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("E-Mail",
                        style: GoogleFonts.varelaRound(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18))),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 3),
                              color: Colors.black12,
                            )
                          ]),
                      child: TextFormField(
                        style: TextStyle(color: Palette.kDarkRedTextColor),
                        validator: _validateEmail,
                        controller: emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.email_outlined, color: Colors.red),
                            hintText: " Enter your E-Mail address",
                            hintStyle: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                    color: Colors.red[200], fontSize: 18))),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding:
                    EdgeInsets.only(bottom: 50, top: 12, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password",
                        style: GoogleFonts.varelaRound(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18))),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 3),
                              color: Colors.black12,
                            )
                          ]),
                      child: TextFormField(
                        style: TextStyle(color: Palette.kDarkRedTextColor),
                        validator: _validatePassword,
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.vpn_key_outlined, color: Colors.red),
                            hintText: " Enter your password",
                            hintStyle: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                    color: Colors.red[200], fontSize: 18))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          context.read<AuthenticationService>().signIn(
                              emailController.text.trim(),
                              passwordController.text.trim());
                        }
                      },
                      child: Text("Log in",
                          style: GoogleFonts.varelaRound(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  letterSpacing: 1.2))))),
              Expanded(child: Container()),
              Container(
                  margin: EdgeInsets.only(bottom: 120),
                  child: Center(
                    child: Text("Sign up",
                        style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1.6))),
                  )),
            ]),
          ),
        ],
      ),
    ));
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
