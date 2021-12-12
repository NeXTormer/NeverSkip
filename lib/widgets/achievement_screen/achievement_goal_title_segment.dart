import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';

class AchievementGoalTitleSegment extends StatefulWidget {
  const AchievementGoalTitleSegment(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

  @override
  _AchievementGoalTitleSegmentState createState() =>
      _AchievementGoalTitleSegmentState();
}

class _AchievementGoalTitleSegmentState
    extends State<AchievementGoalTitleSegment> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Text(widget.goal.title),
      ),
    );
  }
}
