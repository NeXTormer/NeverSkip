import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericCard extends StatelessWidget {
  const FredericCard(
      {this.width,
      this.height,
      this.borderRadius = 10,
      this.padding,
      this.margin,
      this.child,
      this.color});

  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        child: child,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
            border: Border.all(color: kCardBorderColor)));
  }
}
