import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/widgets/profile_screen/goal/finish_goal_view.dart';

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
              textColor: kTextColor,
              splashColor: kDarkColor,
              highlightedBorderColor: kMainColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: FinishGoalView(goal, Mode.ACHIEVEMENT),
                        ),
                      );
                    });
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
