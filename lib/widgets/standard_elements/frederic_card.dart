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
      this.onTap});

  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return _buildContainer();
    return Container(
      child: Stack(
        children: [
          _buildContainer(),
          Container(
            width: width,
            height: height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                splashColor: Colors.grey.withAlpha(32),
                highlightColor: Colors.grey.withAlpha(15),
                onTap: onTap,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: Colors.transparent),
                    padding: EdgeInsets.all(12)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContainer() {
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
