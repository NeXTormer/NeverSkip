import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/providers/goals.dart';
import 'package:frederic/widgets/profile_screen/achievement_item.dart';

/// The [AchievementPage] displays the finished and saved goals in a circular style
///
/// Gets all goals in a [List<GoalItem> achievements].
/// Iterates through [achievements] and generates a corresponding [AchievementItem], which takes a [GoalItem] as argument.
class AchievementPage extends StatefulWidget {
  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<FredericGoal> achievements;
  FredericGoalManager goalManager;

  @override
  void initState() {
    goalManager = FredericBackend.instance().goalManager;
    goalManager.addListener(updateData);
    achievements = goalManager.goals;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 65,
      child: ListView.builder(
        //TODO: maybe swap with GridView
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        itemBuilder: (context, index) => AchievementItem(achievements[index]),
      ),
    );
  }

  void updateData() {
    setState(() {
      achievements = goalManager.achievements;
    });
  }

  @override
  void dispose() {
    goalManager.removeListener(updateData);
    super.dispose();
  }
}
