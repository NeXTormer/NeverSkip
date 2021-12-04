import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/achievement_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AchievementGoalCard extends StatelessWidget {
  const AchievementGoalCard(this.goal, {this.index = 0});

  final FredericGoal goal;
  final int index;

  @override
  Widget build(BuildContext context) {
    String endDateFormatted = DateFormat('dd.MM.yyyy').format(goal.endDate);
    String startDateFormatted = DateFormat('dd.MM.yyyy').format(goal.startDate);
    int usedDays = goal.endDate.difference(goal.startDate).inDays;
    return FredericCard(
        onTap: () {
          handleClick(context);
        },
        onLongPress: () {
          handleLongClick(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: PictureIcon(goal.image),
                        ),
                        SizedBox(width: 16),
                        Container(
                          width: 100,
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                style: TextStyle(
                                    color: const Color(0xFF272727),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.6,
                                    fontSize: 13,
                                    fontFamily: 'Montserrat'),
                                text: goal.title),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      // color: Colors.red,
                      child: Row(
                        children: [
                          Text(
                            '${goal.currentState}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Kilograms',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  FredericChip(
                    'Duration: $usedDays days',
                    fontSize: 14,
                    color: index.isOdd ? theme.mainColor : theme.accentColor,
                  ),
                  Text(
                    '$startDateFormatted',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: 2,
                    width: 8,
                  ),
                  Text(
                    '$endDateFormatted',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void handleClick(BuildContext context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context, builder: (c) => AchievementScreen(goal));
  }

  void handleLongClick(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => FredericActionDialog(
              onConfirm: () {
                // FredericBackend.instance.goalManager.deleteGoal(widget.goal);
                goal.isDeleted = true;
                Navigator.of(context).pop();
              },
              destructiveAction: true,
              title: 'Confirm deletion',
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                    "Do you want to delete your achievement? '${goal.title}' This cannot be undone!",
                    textAlign: TextAlign.center),
              ),
            ));
  }
}
