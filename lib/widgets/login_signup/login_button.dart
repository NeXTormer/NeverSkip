import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            onPressed: onPressed,
            child: Text(text,
                style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        letterSpacing: 1.2)))));
  }
}
