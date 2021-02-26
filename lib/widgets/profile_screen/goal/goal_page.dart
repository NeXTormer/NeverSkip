import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_item.dart';

/// Displays the [List<CardGoalItem>] corresponding to the user's currently created goals.
///
/// Takes a [Function] argument in the constructur, which get passed in the respectively [CardGoalItem] item.
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
          Text('Set a goal using the + button.',
              style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          SizedBox(height: 2)
        ],
      )));

    return Container(
      height: 240,
      child: ListView.builder(
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: goals.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CardGoalItem(goals[index]));
          }),
    );
  }

  void updateData() {
    setState(() {
      goals = goalManager.goals;
    });
  }
}
