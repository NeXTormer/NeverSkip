import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/achievement_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card_medaille_indicator.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';

class AchievementGoalCard extends StatelessWidget {
  const AchievementGoalCard(this.goal, {this.index = 0});

  final FredericGoal goal;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      onTap: () {
        handleClick(context);
      },
      onLongPress: () {
        handleLongClick(context);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: PictureIcon(goal.image),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        buildTitleAndDurationChip(),
                        buildProgressBarWithLabels(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -3,
            left: 23,
            child: GoalCardMedailleIndicator(size: 25),
          ),
        ],
      ),
    );
  }

  Widget buildProgressBarWithLabels() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${goal.startState} kg',
                  style: TextStyle(fontSize: 12, color: theme.greyTextColor),
                ),
              ),
              Flexible(
                child: Text(
                  '${goal.endState} kg',
                  style: TextStyle(fontSize: 12, color: theme.greyTextColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: ProgressBar(
                  1,
                  alternateColor: index % 2 != 0 ? false : true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitleAndDurationChip() {
    int _durationOfGoalInDays = goal.endDate.difference(goal.startDate).inDays;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '${goal.title}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 12),
        Flexible(
            flex: 1,
            child: FredericChip('$_durationOfGoalInDays days',
                color: index % 2 != 0 ? theme.mainColor : theme.accentColor)),
      ],
    );
  }

  void handleClick(BuildContext context) {
    showFredericBottomSheet(
        context: context, builder: (c) => AchievementScreen(goal, context));
  }

  void handleLongClick(BuildContext context) {
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
          Navigator.of(context).pop();
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
