import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/widgets/achievement_screen/achievement_timeline.dart';

class AchievementTimelineSegment extends StatelessWidget {
  const AchievementTimelineSegment(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
            child: AchievementTimeline(
              goal,
              width: 330,
              height: 5,
              delayInMillisecond: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
