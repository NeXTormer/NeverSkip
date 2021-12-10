import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericChip extends StatelessWidget {
  FredericChip(this.text, {Key? key, this.fontSize = 10, Color? color})
      : super(key: key) {
    this.color = color ?? theme.accentColor;
  }

  final String text;
  late final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(
            color: Colors.white, fontSize: fontSize, letterSpacing: 0.3),
      ),
    );
  }
}
