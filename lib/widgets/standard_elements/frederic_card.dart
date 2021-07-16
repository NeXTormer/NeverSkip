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
      this.color,
      this.onLongPress,
      this.onTap});

  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color? color;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
          border: Border.all(color: kCardBorderColor)),
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
          splashColor: Colors.grey.withAlpha(32),
          highlightColor: Colors.grey.withAlpha(15),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            child: child,
            padding: padding,
            margin: margin,
          ),
        ),
      ),
    );
  }
}
