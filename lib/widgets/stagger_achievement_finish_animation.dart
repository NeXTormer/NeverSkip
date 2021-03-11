import 'package:flutter/material.dart';
import 'dart:math' as math;

class StaggerAchievementFinishAnimation extends StatelessWidget {
  StaggerAchievementFinishAnimation({Key key, this.controller})
      : opacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0,
              0.2,
              curve: Curves.easeInQuart,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 20,
          end: 100,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        rotation = Tween<double>(
          begin: 0,
          end: math.pi * 3,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        fontSize = Tween<double>(begin: 0, end: 16).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.2,
              0.3,
              curve: Curves.easeInOutBack,
            ),
          ),
        ),
        padding = Tween<double>(
          begin: 0,
          end: 300,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              0.9,
              curve: Curves.easeIn,
            ),
          ),
        ),
        fadingOpacity = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.8,
              0.9,
              curve: Curves.easeIn,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> fontSize;
  final Animation<double> rotation;
  final Animation<double> padding;
  final Animation<double> fadingOpacity;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Opacity(
      opacity: fadingOpacity.value,
      child: Container(
        padding: EdgeInsets.only(bottom: padding.value),
        height: 500,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: rotation.value,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Opacity(
                    opacity: opacity.value,
                    child: Image.asset('lib/assets/images/dumbbell2.png')),
              ),
            ),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
