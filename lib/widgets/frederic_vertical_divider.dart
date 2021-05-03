import 'package:flutter/material.dart';

class FredericVerticalDivider extends StatelessWidget {
  const FredericVerticalDivider({this.length = 18, this.thickness = 1});

  final double length;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: thickness,
      height: length,
      decoration: BoxDecoration(
          color: const Color(0xFFCDCDCD),
          borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }
}
