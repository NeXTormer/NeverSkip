import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/providers/goals.dart';

/// Clickable circle avatar with information of the [respectivly GoalItem]
///
/// Show various information of the [GoalItem] on tap.
/// currently show a static text.
class AchievementItem extends StatelessWidget {
  final FredericGoal goal;

  AchievementItem(this.goal);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          OutlineButton(
              textColor: kMainColor,
              splashColor: kDarkColor,
              highlightedBorderColor: kMainColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(goal.title),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Container(
                  height: 40,
                  child: Center(
                      child: Row(
                    children: [
                      Icon(
                        Icons.fitness_center_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(goal.title),
                    ],
                  )))),
        ],
      ),
    );
  }
}
