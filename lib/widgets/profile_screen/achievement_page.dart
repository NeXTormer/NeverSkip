import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/widgets/profile_screen/achievement_item.dart';

/// The [AchievementPage] displays the finished and saved goals in a circular style
///
/// Gets all goals in a [List<GoalItem> achievements].
/// Iterates through [achievements] and generates a corresponding [AchievementItem], which takes a [GoalItem] as argument.
class AchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 65,
      child: ListView.builder(
        //TODO: maybe swap with GridView
        scrollDirection: Axis.horizontal,
        //itemCount: snapshot.data.length,
        //itemBuilder: (context, index) => AchievementItem(snapshot.data[index]),
      ),
    );
  }
}
