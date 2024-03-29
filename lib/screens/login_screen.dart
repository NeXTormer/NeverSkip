import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_auth_event.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/login_screen/authenticate_with_email_button.dart';
import 'package:frederic/widgets/login_screen/sign_in_with_google_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

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
    bool medScreen = screenHeight < 900;

    return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
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
                            child: Text(
                                login
                                    ? tr('login.title')
                                    : tr('login.title_signup'),
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
                                  login
                                      ? tr('login.subtitle')
                                      : tr('login.subtitle_signup'),
                                  key: ValueKey<String>(
                                      login ? 'login' : 'signup'),
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
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          AuthenticateWithEmailButton(
                            login: login,
                            hasError: hasError,
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
                          if (Platform.isIOS) SizedBox(height: 20),
                          if (Platform.isIOS)
                            SignInWithAppleButton(
                                borderRadius: BorderRadius.circular(10),
                                style: theme.isDark
                                    ? SignInWithAppleButtonStyle.white
                                    : SignInWithAppleButtonStyle.black,
                                onPressed: () => handleAppleSignIn(context)),
                          SizedBox(height: 20),
                          if (Platform.isAndroid)
                            SignInWithGoogleButton(
                              signUp: !login,
                            ),
                          if (Platform.isAndroid) SizedBox(height: 12),
                          if (hasError)
                            Align(
                              alignment: Alignment.center,
                              child: Text(errorText,
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 14)),
                            ),
                          //Expanded(flex: 50, child: Container()),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                login
                                    ? tr('login.not_have_account')
                                    : tr('login.have_account'),
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
                                  login
                                      ? tr('login.sign_up')
                                      : tr('login.log_in'),
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
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void handleAppleSignIn(BuildContext context) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        nonce: nonce,
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
      );

      FredericBackend.instance.userManager.add(FredericOAuthSignInEvent(
          oauthCredential,
          context: context,
          name:
              '${credential.givenName ?? ''} ${credential.familyName ?? ''}'));
    } catch (e) {
      print(e);
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void dispose() {
    super.dispose();

    streamSubscription?.cancel();
  }
}
