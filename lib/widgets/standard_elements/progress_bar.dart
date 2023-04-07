import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar(this.progress,
      {this.vertical = false,
      this.alternateColor = false,
      this.thickness = 6,
      this.length = 180});

  final double thickness;
  final double length;
  final double progress;
  final bool vertical;
  final bool alternateColor;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: vertical ? 3 : 0,
        child: Container(
            height: thickness,
            width: length,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: alternateColor
                    ? theme.accentColorLight.withAlpha(255)
                    : theme.mainColorLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                    alternateColor ? theme.accentColor : theme.mainColor),
              ),
            )));
  }
}
