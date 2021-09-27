import 'package:flutter/material.dart';

import '../../main.dart';

class ActivityMuscleGroupButton extends StatelessWidget {
  const ActivityMuscleGroupButton(String label,
      {required this.isActive,
      required this.rightPadding,
      required this.onPressed,
      Key? key})
      : this.label = label,
        super(key: key);

  final Function() onPressed;
  final double rightPadding;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          color: theme.backgroundColor,
          child: Padding(
            padding: EdgeInsets.only(right: rightPadding, top: 10, bottom: 10),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? theme.mainColor : theme.greyColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 12,
              ),
            ),
          ),
        ));
  }
}
