import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GoalCardMedailleIndicator extends StatefulWidget {
  const GoalCardMedailleIndicator({this.size = 25, Key? key}) : super(key: key);
  final double size;

  @override
  _GoalCardMedailleIndicatorState createState() =>
      _GoalCardMedailleIndicatorState();
}

class _GoalCardMedailleIndicatorState extends State<GoalCardMedailleIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
        'https://assets9.lottiefiles.com/packages/lf20_nywmyj3y.json',
        
        width: widget.size,
        height: widget.size,
        controller: _controller, onLoaded: (composition) {
      Future.delayed(Duration(milliseconds: 200), () {
        _controller
          ..duration = composition.duration
          ..forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
