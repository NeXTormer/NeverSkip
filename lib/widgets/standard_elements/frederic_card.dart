import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      this.duration = const Duration(milliseconds: 200),
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
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      width: width,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
          border: Border.all(color: kCardBorderColor)),
      child: Container(
        height: height,
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            splashColor: Colors.grey.withAlpha(32),
            highlightColor: Colors.grey.withAlpha(15),
            onTap: onTap,
            onLongPress: onLongPress == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onLongPress!.call();
                  },
            child: Container(
              child: child,
              padding: padding,
            ),
          ),
        ),
      ),
    );
  }
}
