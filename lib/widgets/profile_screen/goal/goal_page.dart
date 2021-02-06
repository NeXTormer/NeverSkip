import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_item.dart';
import 'package:provider/provider.dart';

/// Displays the [List<CardGoalItem>] corresponding to the user's currently created goals.
///
/// Takes a [Function] argument in the constructur, which get passed in the respectively [CardGoalItem] item.
class GoalPage extends StatelessWidget {
  GoalPage(this.showSlidesheet);
  final Function showSlidesheet;
  @override
  Widget build(BuildContext context) {
    Stream<List<FredericGoal>> stream =
        FredericBackend.of(context).loadGoalStream();

    return StreamBuilder<List<FredericGoal>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0)
            return Container(child: Center(child: Text('no goals yet')));
          return Container(
            height: 240,
            child: ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child:
                          CardGoalItem(snapshot.data[index], showSlidesheet));
                }),
          );
        });
  }
}
