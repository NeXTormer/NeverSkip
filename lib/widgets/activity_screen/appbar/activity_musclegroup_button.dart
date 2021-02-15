import 'package:flutter/material.dart';

class ActivityMuscleGroupButton extends StatelessWidget {
  ActivityMuscleGroupButton(String label,
      {@required this.isActive, @required this.onPressed})
      : this.label = label;

  final Function onPressed;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: isActive
            ? Container(
                height: 25,
                width: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(170, 255, 165, 0),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.orange[50],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              )
            : Container(
                height: 25,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 14.0, color: Colors.black45),
                  ),
                ),
              ));
  }
}
