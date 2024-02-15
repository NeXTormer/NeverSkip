import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class FredericScaffold extends StatelessWidget {
  const FredericScaffold(
      {Key? key,
      required this.body,
      this.floatingActionButton,
      this.backgroundColor,
      this.floatingActionButtonLocation})
      : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoStackedTransition(
      cornerRadius: Tween(begin: 0.0, end: 16.0),
      child: Scaffold(
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        backgroundColor: backgroundColor ??
            (theme.isColorful ? theme.mainColor : theme.backgroundColor),
        body: SafeArea(
          child: Container(
            color: theme.backgroundColor,
            child: body,
          ),
        ),
      ),
    );
  }
}
