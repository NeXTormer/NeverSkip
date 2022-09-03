import 'package:flutter/material.dart';

class FredericVerticalDivider extends StatelessWidget {
  const FredericVerticalDivider(
      {this.length = 18,
      this.thickness = 1,
      this.color = const Color(0xFFCDCDCD)});

  final double length;
  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: thickness,
      height: length,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }
}
