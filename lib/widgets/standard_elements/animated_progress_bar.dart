import 'package:flutter/material.dart';

import '../../main.dart';

class AnimatedProgressBar extends ImplicitlyAnimatedWidget {
  const AnimatedProgressBar(
      {required this.progress,
      required Duration duration,
      this.vertical = false,
      this.alternateColor = false,
      this.thickness = 6,
      this.length = 180})
      : super(duration: duration, curve: Curves.easeIn);

  final double thickness;
  final double length;
  final double progress;
  final bool vertical;
  final bool alternateColor;

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState
    extends AnimatedWidgetBaseState<AnimatedProgressBar> {
  Tween<double>? valueTween;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: widget.vertical ? 3 : 0,
      child: Container(
          height: widget.thickness,
          width: widget.length,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: TweenAnimationBuilder<double>(
                curve: Curves.easeIn,
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: valueTween?.evaluate(this.animation),
                    backgroundColor: widget.alternateColor
                        ? theme.accentColorLight
                        : theme.mainColorLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        widget.alternateColor
                            ? theme.accentColor
                            : theme.mainColor),
                  );
                }),
          )),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    valueTween = visitor(valueTween, widget.progress,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
  }
}
