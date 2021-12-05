import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/achievement_screen/achievement_goal_title_segment.dart';
import 'package:frederic/widgets/achievement_screen/achievement_header.dart';
import 'package:frederic/widgets/achievement_screen/achievement_progress_segment.dart';
import 'package:frederic/widgets/achievement_screen/achievement_stats_segment.dart';
import 'package:frederic/widgets/achievement_screen/achievement_timeline_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card_medaille_indicator.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: ModalScrollController.of(context),
            slivers: [
              AchievementHeader(),
              SliverDivider(),
              _AchievementTitle('Title'),
              AchievementGoalTitleSegment(goal),
              _AchievementTitle('Your Progress'),
              AchievementProgressSegment(goal),
              _AchievementTitle('Stats'),
              AchievementStatsSegment(goal),
              AchievementTimelineSegment(goal),
            ],
          ),
          Positioned(
            right: 30,
            top: -8,
            child: GoalCardMedailleIndicator(
              size: 90,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTitle extends StatelessWidget {
  const _AchievementTitle(this.text);
  final String text;

  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FredericHeading(text),
      ),
    );
  }
}
