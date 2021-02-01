import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/widget/second_design/goal/goal_item.dart';
import 'package:provider/provider.dart';

/// Displays the [List<CardGoalItem>] corresponding to the user's currently created goals.
///
/// Takes a [Function] argument in the constructur, which get passed in the respectively [CardGoalItem] item.
class GoalPage extends StatelessWidget {
  final Function showSlidesheet;
  GoalPage(this.showSlidesheet);
  @override
  Widget build(BuildContext context) {
    final goalsData = Provider.of<Goals>(context);
    final goals = goalsData.unfinishedGoals;
    return Container(
      height: 231,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goals.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: goals[i],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CardGoalItem(goals[i], showSlidesheet),
          ),
        ),
      ),
    );
  }
}
