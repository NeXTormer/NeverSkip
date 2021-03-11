import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';

class SaveGoalButtons extends StatefulWidget {
  SaveGoalButtons(this.goal);
  final FredericGoal goal;

  @override
  _SaveGoalButtonsState createState() => _SaveGoalButtonsState();
}

class _SaveGoalButtonsState extends State<SaveGoalButtons> {
  bool saveToAchievementState = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        FlatButton(
          color: Colors.blue,
          onPressed: () {
            if (saveToAchievementState) {
              // Save goal
            } else {
              // Discard goal
            }
            Navigator.of(context).pop();
          },
          child: Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        Positioned(
          top: -10,
          left: -10,
          child: InkWell(
            onTap: () {
              setState(() {
                saveToAchievementState = !saveToAchievementState;
              });
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                saveToAchievementState ? Icons.favorite : Icons.favorite_border,
                size: 25,
                color: Colors.red,
              ),
            ),
          ),
        )
      ],
    );
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     IconButton(
    //       iconSize: 30,
    //       color: Colors.red,
    //       icon: Icon(
    //           saveToAchievementState ? Icons.favorite : Icons.favorite_border),
    //       onPressed: () {
    //         setState(() {
    //           saveToAchievementState = !saveToAchievementState;
    //         });
    //       },
    //     ),
    //
    //   ],
    // );
  }
}
