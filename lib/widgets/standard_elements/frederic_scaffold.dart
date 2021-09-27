import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericScaffold extends StatelessWidget {
  const FredericScaffold(
      {Key? key,
      required this.body,
      this.floatingActionButton,
      this.floatingActionButtonLocation})
      : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          theme.isColorful ? theme.mainColor : theme.backgroundColor,
      body: SafeArea(
        child: Container(
          color: theme.backgroundColor,
          child: body,
        ),
      ),
    );
  }
}
