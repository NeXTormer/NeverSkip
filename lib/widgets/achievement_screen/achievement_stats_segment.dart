import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';

class AchievementStatsSegment extends StatelessWidget {
  const AchievementStatsSegment(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleWithTitleAndText('Work in progress', 'xx\nmin'),
            _buildCircleWithTitleAndText('Work in progress', 'xx\nmin')
          ],
        ),
      ),
    );
  }

  Widget _buildCircleWithTitleAndText(String title, String text) {
    return Column(
      children: [
        Text(title),
        SizedBox(height: 10),
        CircleAvatar(
          radius: 40,
          backgroundColor: theme.mainColor,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: theme.backgroundColor,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.textColor),
              ),
            ),
          ),
        )
      ],
    );
  }
}
