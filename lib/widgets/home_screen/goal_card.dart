import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';

class GoalCard extends StatelessWidget {
  GoalCard(this.goal);

  final FredericGoal goal;

  @override
  Widget build(BuildContext context) {
    final num currentStateNormalized = (goal.currentState - goal.startState) /
        (goal.endState - goal.startState);
    return FredericCard(
      width: 260,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          PictureIcon(goal.image),
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
                            text: '${goal.title}',
                            style: const TextStyle(
                                color: const Color(0x7A3A3A3A),
                                fontSize: 10,
                                letterSpacing: 0.3),
                          ),
                        ),
                      ),
                      Flexible(
                        child: FredericChip(
                            '${goal.endDate.difference(goal.startDate).inDays} days'),
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
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${goal.startState} ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: 'kg'),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${goal.endState} ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: 'kg'),
                                  ],
                                ),
                              ),
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
}
