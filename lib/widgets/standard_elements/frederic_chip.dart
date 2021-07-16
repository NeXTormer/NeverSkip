import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericChip extends StatelessWidget {
  const FredericChip(this.text, {Key? key, this.fontSize = 10})
      : super(key: key);

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: kAccentColor,
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: fontSize, letterSpacing: 0.3),
      ),
    );
  }
}