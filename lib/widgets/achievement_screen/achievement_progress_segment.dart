import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';

import 'achievement_progress_bar.dart';

class AchievementProgressSegment extends StatelessWidget {
  const AchievementProgressSegment(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double adjustedProgressBarLength = deviceWidth - 100;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Column(
          children: [
            buildSubHeading('Starting Level', Icons.sports_volleyball),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AchievementProgressBar(goal, goal.startState.toDouble(),
                      progressRatio: 0.1, length: adjustedProgressBarLength),
                ],
              ),
            ),
            SizedBox(height: 30),
            buildSubHeading('Finish Level', Icons.sports_mma_outlined),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AchievementProgressBar(
                    goal,
                    goal.endState.toDouble(),
                    progressRatio: 0.96,
                    delayInMillisecond: 0,
                    length: adjustedProgressBarLength,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: theme.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
