import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FredericCircularProgressIndicator extends StatefulWidget {
  FredericCircularProgressIndicator(
      {this.staticProgress = -1,
      this.image = true,
      this.size = 112,
      this.stroke = 10,
      this.increment = 0.02,
      this.onFinished})
      : isStatic = staticProgress != -1;

  final image;
  final double size;
  final double stroke;
  final double increment;
  final double staticProgress;
  final Function? onFinished;
  final bool isStatic;

  @override
  _FredericCircularProgressIndicatorState createState() =>
      _FredericCircularProgressIndicatorState();
}

class _FredericCircularProgressIndicatorState
    extends State<FredericCircularProgressIndicator> {
  double progress = 0;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    if (widget.staticProgress == -1)
      timer = Timer.periodic(Duration(milliseconds: 16), (Timer t) {
        setState(() {
          progress += widget.increment;
          if (progress >= 1) {
            t.cancel();
            if (widget.onFinished != null) {
              widget.onFinished!();
            }
          }
        });
      });
    else
      progress = widget.staticProgress;
  }

  @override
  Widget build(BuildContext context) {
    if (progress > 1) progress = 1;
    if (progress < 0) progress = 0;
    double? curveProgress = widget.isStatic
        ? widget.staticProgress
        : Curves.easeInOutExpo.transform(progress);

    double innerRadius = widget.size - (widget.stroke * 2);

    return Stack(alignment: Alignment.center, children: [
      Container(
        width: widget.size,
        height: widget.size,
        decoration:
            BoxDecoration(color: Color(0xFFD1E8F8), shape: BoxShape.circle),
      ),
      Container(
        width: widget.size - (widget.stroke * 2),
        height: widget.size - (widget.stroke * 2),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
      ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(colors: [Colors.red, Colors.orange])
              .createShader(rect);
        },
        child: RotatedBox(
          quarterTurns: 3,
          child: ShaderMask(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            shaderCallback: (rect) {
              return SweepGradient(
                      startAngle: 0,
                      endAngle: 2 * pi,
                      stops: [curveProgress, curveProgress],
                      // 0.0 , 0.5 , 0.5 , 1.0
                      center: Alignment.center,
                      colors: [Colors.white, Colors.transparent])
                  .createShader(rect);
            },
          ),
        ),
      ),
      //if (widget.image)
      Container(
        width: widget.size - (widget.stroke * 2),
        height: widget.size - (widget.stroke * 2),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
      Image(
        width: innerRadius - 20,
        image: AssetImage('assets/images/dumbbell_with_bg_blue.png'),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
