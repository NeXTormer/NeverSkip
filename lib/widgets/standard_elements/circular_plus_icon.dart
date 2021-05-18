import 'package:flutter/material.dart';

import '../../main.dart';

class CircularPlusIcon extends StatelessWidget {
  CircularPlusIcon(
      {this.radius = 15,
      this.width = 2,
      required this.onPressed,
      this.iconSize = 0});

  final Function onPressed;
  final double radius;
  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: kMainColor,
        child: CircleAvatar(
          radius: radius - width,
          backgroundColor: Colors.white,
          child: Center(
            child: Icon(
              Icons.add,
              size: iconSize == 0 ? radius * 2 - 5 : iconSize,
              color: kMainColor,
            ),
          ),
        ),
      ),
    );
  }
}
