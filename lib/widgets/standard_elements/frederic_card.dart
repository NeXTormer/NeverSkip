import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/main.dart';
import 'package:shimmer/shimmer.dart';

class FredericCard extends StatelessWidget {
  const FredericCard(
      {this.width,
      this.height,
      this.borderRadius = 10,
      this.borderWidth = 1,
      this.padding,
      this.margin,
      this.child,
      this.color,
      this.animated = false,
      this.shimmer = false,
      this.duration = const Duration(milliseconds: 200),
      this.onLongPress,
      this.onTap});

  final double? width;
  final double? height;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color? color;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Duration duration;
  final bool animated;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color ?? theme.cardBackgroundColor,
        border: borderWidth == 0
            ? null
            : Border.all(color: theme.cardBorderColor, width: borderWidth));

    Container container = Container(
        height: height,
        child: Material(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.transparent,
            child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius))),
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
                ))));

    if (animated)
      return AnimatedContainer(
          width: width,
          height: height,
          duration: duration,
          margin: margin,
          decoration: decoration,
          child: container);
    else
      return Stack(
        fit: StackFit.passthrough,
        children: [
          if (shimmer)
            Shimmer.fromColors(
              period: Duration(seconds: 1),
              child: Container(
                width: width,
                height: height,
                margin: margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Colors.black,
                ),
              ),
              baseColor: Colors.yellow.shade50,
              highlightColor: Colors.white,
            ),
          Container(
            width: width,
            height: height,
            margin: margin,
            decoration: decoration,
            child: container,
          ),
        ],
      );
  }
}
