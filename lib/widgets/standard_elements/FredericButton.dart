import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FredericButton extends StatelessWidget {
  FredericButton(this.text,
      {required this.onPressed,
      this.mainColor = const Color(0xFF3E4FD8),
      this.textColor = const Color(0xFFFFFFFF)});
  final Color mainColor;
  final Color textColor;
  final double height = 44;
  final String text;

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: mainColor),
        child: Center(
            child: Text(
          text,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  letterSpacing: 0.2,
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14)),
        )),
      ),
    );
  }
}
