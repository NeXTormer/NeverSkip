import 'package:flutter/material.dart';
import 'package:frederic/widgets/circle_loading_progress_spinner_painter.dart';

/*
  ----------------------------------------------
  Test Enviroment - probably not gonna be used.
  Do not delete yet.
  ----------------------------------------------
*/

class CircleLoadingProgressSpinner extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;

  const CircleLoadingProgressSpinner({
    Key key,
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.value,
  }) : super(key: key);

  @override
  _CircleLoadingProgressSpinnerState createState() =>
      _CircleLoadingProgressSpinnerState();
}

class _CircleLoadingProgressSpinnerState
    extends State<CircleLoadingProgressSpinner>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> curve;
  Tween<double> valueTween;

  @override
  void initState() {
    this._controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    this._controller.forward();

    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value,
    );

    this.curve = CurvedAnimation(
      parent: this._controller,
      curve: Curves.easeInCubic,
    );

    this._controller.forward();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircleLoadingProgressSpinner oldWidget) {
    if (this.widget.value != oldWidget.value) {
      // Try to start with the previous tween's end value. This ensures that we
      // have a smooth transition from where the previous animation reached.
      double beginValue =
          this.valueTween?.evaluate(this.curve) ?? oldWidget?.value ?? 0;

      //Update value tween
      this.valueTween = Tween<double>(
        begin: beginValue,
        end: this.widget.value ?? 1,
      );

      this._controller
        ..value = 0
        ..forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.widget.backgroundColor;
    final foregroundColor = this.widget.foregroundColor;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: AnimatedBuilder(
              animation: this.curve,
              child: Container(),
              builder: (context, child) {
                return CustomPaint(
                  child: child,
                  foregroundPainter: CircleLoadingProgressSpinnerPainter(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    percentage: this.valueTween.evaluate(this.curve),
                  ),
                );
              }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }
}
