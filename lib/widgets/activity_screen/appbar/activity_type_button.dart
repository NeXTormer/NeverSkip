import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class ActivityTypeButton extends StatelessWidget {
  const ActivityTypeButton(
      {@required this.isActive,
      @required this.onPressed,
      @required this.iconData});

  final bool isActive;
  final Function onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isActive
              ? kMainColor
              : Colors.transparent, //Color.fromARGB(170, 255, 165, 0)
          border: Border.all(
            width: 1.0,
            color: isActive ? Colors.white54 : Colors.black26,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          iconData,
          size: 25,
          color: isActive ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
