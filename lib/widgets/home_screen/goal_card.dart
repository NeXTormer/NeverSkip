import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/screens/edit_goal_data_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GoalCard extends StatefulWidget {
  const GoalCard(this.goal,
      {this.title,
      this.startState,
      this.currentState,
      this.endState,
      this.startDate,
      this.endDate});
  const GoalCard.dummy(this.goal,
      {this.title,
      this.startState,
      this.currentState,
      this.endState,
      this.startDate,
      this.endDate});

  final FredericGoal goal;

  final String? title;
  final num? startState;
  final num? currentState;
  final num? endState;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    final num currentStateNormalized =
        ((widget.currentState ?? widget.goal.currentState) -
                (widget.startState ?? widget.goal.startState)) /
            ((widget.endState ?? widget.goal.endState) -
                (widget.startState ?? widget.goal.startState));
    return FredericCard(
      onLongPress: () {
        handleLongClick(context);
      },
      onTap: () {
        handleClick(context);
      },
      width: 260,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          PictureIcon(widget.goal.image),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 10),
                          text: TextSpan(
                            text: '${widget.title ?? widget.goal.title}',
                            style: const TextStyle(
                                color: const Color(0x7A3A3A3A),
                                fontSize: 10,
                                letterSpacing: 0.3),
                          ),
                        ),
                      ),
                      Flexible(
                        child: FredericChip(
                            '${widget.goal.endDate.difference(widget.goal.startDate).inDays} days'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: buildProgressBarText(
                                  widget.goal.startState, 'kg'),
                            ),
                            Flexible(
                              child: buildProgressBarText(
                                  widget.goal.endState, 'kg'),
                            ),
                          ],
                        ),
                      ),
                      ProgressBar(currentStateNormalized.toDouble()),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProgressBarText(var text, String unit) {
    return RichText(
      text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '$text',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            TextSpan(text: ' '),
            TextSpan(text: '$unit')
          ]),
    );
  }

  void handleClick(BuildContext context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (c) => Scaffold(body: EditGoalDataScreen(widget.goal)));
  }

  void handleLongClick(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => FredericActionDialog(
              onConfirm: () {
                FredericBackend.instance.goalManager
                    .deleteGoal(widget.goal.goalID);
                Navigator.of(context).pop();
              },
              destructiveAction: true,
              title: 'Confirm deletion',
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                    "Do you want to delete your personal goal? '${widget.goal.title}' This cannot be undone!",
                    textAlign: TextAlign.center),
              ),
            ));
  }
}
