import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class SignInWithGoogleButton extends StatelessWidget {
  SignInWithGoogleButton({this.signUp = false, Key? key}) : super(key: key);

  final bool signUp;
  final Color brightColor = Colors.white;
  final Color darkColor = const Color(0xFF4285F4);

  @override
  Widget build(BuildContext context) {
    bool dark = theme.isDark;
    return Container(
      height: 44,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: dark ? darkColor : brightColor,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/google/google_logo_light.png',
          ),
          SizedBox(width: 24),
          Text(
            '${signUp ? 'Sign up' : 'Log in'} with Google',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: dark ? Colors.white : Colors.grey),
          )
        ],
      ),
    );
  }
}
