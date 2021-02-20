import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_item.dart';

/// Displays the [List<CardGoalItem>] corresponding to the user's currently created goals.
///
/// Takes a [Function] argument in the constructur, which get passed in the respectively [CardGoalItem] item.
class GoalPage extends StatelessWidget {
  GoalPage(this.showSlidesheet);
  final Function showSlidesheet;
  @override
  Widget build(BuildContext context) {
    Stream<List<FredericGoal>> stream =
        FredericBackend.instance().loadGoalStream();

    return StreamBuilder<List<FredericGoal>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0)
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
