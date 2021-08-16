import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericButton extends StatelessWidget {
  FredericButton(this.text,
      {required this.onPressed,
      this.mainColor = kMainColor,
      this.textColor = kBrightTextColor,
      this.inverted = false,
      this.fontSize = 15,
      this.fontWeight = FontWeight.w600});
  final Color mainColor;
  final Color textColor;
  final double height = 44;
  final String text;
  final bool inverted;
  final double fontSize;
  final FontWeight fontWeight;

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
            borderRadius: BorderRadius.circular(10),
            border: inverted ? Border.all(color: mainColor) : null,
            color: inverted ? Colors.white : mainColor),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              letterSpacing: 0.2,
              color: inverted ? mainColor : textColor,
              fontWeight: fontWeight,
              fontSize: fontSize),
        )),
      ),
    );
  }
}
