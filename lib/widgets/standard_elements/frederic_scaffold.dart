import 'package:flutter/material.dart';

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
      //extendBodyBehindAppBar: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      // backgroundColor:
      //     theme.isColorful ? theme.mainColor : theme.backgroundColor,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/theme/background1.png',
              fit: BoxFit.cover,
            ),
            Container(
              //color: theme.backgroundColor,
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
