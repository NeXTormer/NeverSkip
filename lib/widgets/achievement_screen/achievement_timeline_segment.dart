import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/widgets/achievement_screen/achievement_timeline.dart';

class AchievementTimelineSegment extends StatelessWidget {
  const AchievementTimelineSegment(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

  static final int waitForOtherAnimationsToLoad = 1000;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double adjustedProgressBarLength = deviceWidth - 50;
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
            child: AchievementTimeline(
              goal,
              length: adjustedProgressBarLength,
              height: 5,
              delayInMillisecond: waitForOtherAnimationsToLoad,
            ),
          ),
        ],
      ),
    );
  }
}
