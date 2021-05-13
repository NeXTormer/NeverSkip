import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';

class GoalCard extends StatelessWidget {
  GoalCard(this.goal);

  final FredericGoal goal;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      width: 260,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          PictureIcon(goal.image),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 132,
                        child: Text(
                          goal.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: const Color(0x7A3A3A3A),
                              fontSize: 10,
                              letterSpacing: 0.3),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                            color: kAccentColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Text(
                          goal.timeLeftFormatted,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              letterSpacing: 0.3),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Row(
                    children: [
                      Text(
                        '${goal.startState}',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 13),
                      ),
                      SizedBox(width: 2),
                      Text('${goal.activity?.bestProgressType}',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 11)),
                      Expanded(child: Container()),
                      Text(
                        '${goal.endState}',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 13),
                      ),
                      SizedBox(width: 2),
                      Text('${goal.activity?.bestProgressType}',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 11))
                    ],
                  ),
                ),
                ProgressBar((goal.progressPercentage / 100).toDouble())
              ],
            ),
          )
        ],
      ),
    );
  }
}
