import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/achievement_screen/triangle_clipper.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class AchievementProgressBar extends StatefulWidget {
  const AchievementProgressBar(this.progress,
      {this.length = 280, this.thickness = 13, Key? key})
      : super(key: key);

  final double progress;
  final double length;
  final double thickness;

  @override
  State<AchievementProgressBar> createState() => _AchievementProgressBarState();
}

class _AchievementProgressBarState extends State<AchievementProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn)
          ..addListener(() {
            setState(() {});
          });

    Future.delayed(Duration(milliseconds: 200), () {
      _controller.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dotPosition =
        _animation.value * widget.progress * widget.length - 15;
    return Container(
      height: widget.thickness * 2,
      width: widget.length,
      child: Stack(
        // fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            child: LinearProgressIndicator(
              minHeight: widget.thickness,
              value: _animation.value * widget.progress,
              backgroundColor: theme.mainColorLight,
              valueColor: AlwaysStoppedAnimation<Color>(theme.mainColor),
            ),
          ),
          Positioned(
            top: -7,
            left: dotPosition,
            child: CircleAvatar(
                backgroundColor: theme.mainColorLight,
                radius: 14,
                child: CircleAvatar(
                  backgroundColor: theme.mainColor,
                  radius: 10,
                )),
          ),
          Positioned(
            top: 8,
            left: dotPosition + 5,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: theme.mainColor,
                width: 20,
                height: 20,
              ),
            ),
          ),
          Positioned(
            top: 28,
            left: dotPosition - 15,
            child: FredericCard(
              width: 70,
              height: 30,
              child: Center(child: Text('100 kg')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
