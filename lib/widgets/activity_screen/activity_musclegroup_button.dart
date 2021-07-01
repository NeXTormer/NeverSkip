import 'package:flutter/material.dart';

import '../../main.dart';

class ActivityMuscleGroupButton extends StatelessWidget {
  ActivityMuscleGroupButton(String label,
      {required this.isActive, required this.onPressed})
      : this.label = label;

  final Function onPressed;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width / 40),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: isActive
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: kMainColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: -10,
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: kMainColor,
                    ),
                  ),
                ],
              )
            : Container(
                child: Text(
                  label,
                  style: TextStyle(
                    color: kGreyColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: 12,
                  ),
                ),
              ),
      ),
    );
  }
}
