import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/theme/frederic_theme.dart';
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
    return Lottie.network(handleColorTheme(),
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

  String handleColorTheme() {
    String path = '';
    switch (theme.name) {
      case 'Bright Blue':
        path = 'https://assets9.lottiefiles.com/packages/lf20_nywmyj3y.json';
        break;
      case 'Colorful Blue':
        path = 'https://assets9.lottiefiles.com/packages/lf20_nywmyj3y.json';
        break;
      case 'Dark Blue':
        path = 'https://assets9.lottiefiles.com/packages/lf20_nywmyj3y.json';
        break;
      case 'Bright Orange':
        path = 'https://assets1.lottiefiles.com/packages/lf20_rmg3y1lk.json';
        break;
      case 'Colorful Orange':
        path = 'https://assets1.lottiefiles.com/packages/lf20_rmg3y1lk.json';
        break;
      case 'Dark Orange':
        path = 'https://assets1.lottiefiles.com/packages/lf20_rmg3y1lk.json';
        break;
      case 'Bright Purple':
        path = 'https://assets5.lottiefiles.com/packages/lf20_dba9atlj.json';
        break;
      case 'Colorful Purple':
        path = 'https://assets5.lottiefiles.com/packages/lf20_dba9atlj.json';
        break;
      case 'Dark Purple':
        path = 'https://assets5.lottiefiles.com/packages/lf20_dba9atlj.json';
        break;
      case 'Bright Pink':
        path = 'https://assets5.lottiefiles.com/packages/lf20_dmzcpxob.json';
        break;
      case 'Colorful Pink':
        path = 'https://assets5.lottiefiles.com/packages/lf20_dmzcpxob.json';
        break;
      case 'Dark Pink':
        path = 'https://assets5.lottiefiles.com/packages/lf20_dmzcpxob.json';
        break;
      default:
        path = 'https://assets9.lottiefiles.com/packages/lf20_nywmyj3y.json';
    }
    return path;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
