import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/achievement_screen/achievement_goal_title_segment.dart';
import 'package:frederic/widgets/achievement_screen/achievement_header.dart';
import 'package:frederic/widgets/achievement_screen/achievement_progress_segment.dart';
import 'package:frederic/widgets/achievement_screen/achievement_stats_segment.dart';
import 'package:frederic/widgets/achievement_screen/achievement_timeline_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card_medaille_indicator.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen(this.goal, this.parentContext, {Key? key})
      : super(key: key);
  final FredericGoal goal;
  final BuildContext parentContext;

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
              buildDeleteButton(),
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

  Widget buildDeleteButton() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 100,
              child: FredericButton(
                'Delete',
                mainColor: Colors.red,
                onPressed: () {
                  handleDelete(parentContext);
                },
                inverted: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => FredericActionDialog(
        onConfirm: () {
          FredericBackend.instance.analytics.logAchievementDeleted();
          var achievementscount =
              FredericBackend.instance.userManager.state.achievementsCount;
          if (achievementscount >= 1)
            FredericBackend.instance.userManager.state.achievementsCount -= 1;
          FredericBackend.instance.goalManager
              .add(FredericGoalDeleteEvent(goal));
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        },
        title: 'Confirm deletion',
        destructiveAction: true,
        child: Text(
            'Do you want to delete your achievement? This cannot be undone!',
            textAlign: TextAlign.center),
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
