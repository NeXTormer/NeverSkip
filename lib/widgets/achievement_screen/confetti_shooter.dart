import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

enum Direction { left, right, up, down }

class ConfettiShooter extends StatefulWidget {
  const ConfettiShooter({this.dir = Direction.down, Key? key})
      : super(key: key);
  final Direction dir;

  @override
  _ConfettiShooterState createState() => _ConfettiShooterState();
}

class _ConfettiShooterState extends State<ConfettiShooter> {
  late ConfettiController controller;
  double blastDirection = 0.0;

  @override
  void initState() {
    blastDirection = getBlastDirection(widget.dir);
    controller = ConfettiController(duration: Duration(seconds: 2));
    controller.play();
    Future.delayed(const Duration(seconds: 2), () {
      controller.stop();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      shouldLoop: true,
      blastDirection: blastDirection,
      // blastDirectionality: BlastDirectionality.explosive,
      confettiController: controller,
      colors: [
        theme.mainColor,
        theme.accentColor,
        theme.accentColorLight,
        theme.mainColorLight,
      ],
      emissionFrequency: 0.1,
      numberOfParticles: 3,
      maxBlastForce: 30,
      minBlastForce: 20,
    );
  }

  double getBlastDirection(Direction dir) {
    double result = 0.0;
    switch (dir) {
      case Direction.left:
        result = pi;
        break;
      case Direction.right:
        result = 0.0;
        break;
      case Direction.up:
        result = -pi / 2;
        break;
      case Direction.down:
        result = pi / 2;
        break;
      default:
    }
    return result;
  }
}
