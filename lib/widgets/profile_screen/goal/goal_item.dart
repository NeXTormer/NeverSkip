import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/providers/goals.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Card item which displays the corresponding [GoalItem] information.
///
/// Uses the passed [Function showSlidesheet] to assign to
/// the [onTap] of the ['Edit Goal'] string in order to edit the [GoalItem] data.
class CardGoalItem extends StatelessWidget {
  CardGoalItem(this.goal);
  final FredericGoal goal;

  /// Checks if the enum [GoalType type] is [GoalType.Weighted]
  ///
  /// Returns a unit if the case is give.
  String goalType(FredericActivityType type) {
    if (type == FredericActivityType.Weighted) {
      return 'kg';
    } else if (type == FredericActivityType.Stretch) {
      return 'seconds';
    } else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: 300,
        /* decoration: BoxDecoration(
          border: Border.all(
            width: 0.1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),*/
        child: Stack(
          children: [
            Container(
              width: 300,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0)),
                child: Image.network(
                  goal.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    //TODO: delete goal with confirmation
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      //TODO: add goal to achievements
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(
                        Icons.done_all,
                        color: Colors.greenAccent[400],
                        size: 25,
                      ),
                    )),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.6)),
                      child: CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 8,
                        percent: goal.progressPercentage / 100,
                        progressColor: Colors.blue[400],
                        center: Container(
                          child: Text(
                            '${goal.progressPercentage}%',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          goal.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${goal.startState} ${goalType(goal.activity?.type)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Start'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${goal.currentState} ${goalType(goal.activity?.type)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Current'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${goal.endState} ${goalType(goal.activity?.type)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Target'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            print('ontapgoal');
                          },
                          child: Text(
                            'Edit Goal',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.timer,
                                color: Colors.black54,
                                size: 20.0,
                              ),
                            ),
                            Text(
                              goal.timeLeftFormatted,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
