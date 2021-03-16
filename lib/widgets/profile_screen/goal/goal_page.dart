import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/profile_screen/goal/add_goal_card.dart';
import 'package:frederic/widgets/profile_screen/goal/add_goal_popup.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_item.dart';

/// Displays the [List<CardGoalItem>] corresponding to the user's currently created goals.
///
class GoalPage extends StatefulWidget {
  GoalPage();

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  FredericGoalManager goalManager;

  List<FredericGoal> goals;

  @override
  void initState() {
    goalManager = FredericBackend.instance().goalManager;
    goalManager.addListener(updateData);
    goals = goalManager.goals;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (goals == null || goals.length == 0)
      return Container(
          child: Center(
              child: Column(
        children: [
          SizedBox(height: 12),
          Text('You have not set any goals yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          SizedBox(
            height: 6,
          ),
          SizedBox(height: 6),
          InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              showDialog(
                  context: context, builder: (context) => AddGoalPopup());
            },
            child: Icon(
              Icons.add_circle_outlined,
              size: 55,
              color: kMainColor,
            ),
          ),
          SizedBox(height: 2),
        ],
      )));

    return Container(
      height: 240,
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: goals.length + 1,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: index == goals.length
                    ? AddGoalCard()
                    : CardGoalItem(goals[index]));
          }),
    );
  }

  void updateData() {
    setState(() {
      goals = goalManager.goals;
    });
  }
}
