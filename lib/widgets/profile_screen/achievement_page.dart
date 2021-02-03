import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/widgets/profile_screen/circle_item.dart';
import 'package:provider/provider.dart';

/// The [AchievementPage] displays the finished and saved goals in a circular style
///
/// Gets all goals in a [List<GoalItem> achievements].
/// Iterates through [achievements] and generates a corresponding [CircleItem], which takes a [GoalItem] as argument.
class AchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final achievementData = Provider.of<Goals>(context);
    final achievements = achievementData.finishedGoals;
    return achievements.isEmpty
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 90,
            child: Column(
              children: [
                Text('-------Empty-------'),
                // TO Do
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              itemBuilder: (ctx, i) => CircleItem(achievements[i]),
            ),
          );
  }
}
