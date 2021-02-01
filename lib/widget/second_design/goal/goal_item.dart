import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';
import 'package:provider/provider.dart';

import 'package:percent_indicator/percent_indicator.dart';

/// Card item which displays the corresponding [GoalItem] information.
///
/// Uses the passed [Function showSlidesheet] to assign to
/// the [onTap] of the ['Edit Goal'] string in order to edit the [GoalItem] data.
class CardGoalItem extends StatelessWidget {
  final GoalItem goal;
  final Function showSlidesheet;

  CardGoalItem(this.goal, this.showSlidesheet);

  /// Checks if the enum [GoalType type] is [GoalType.Weighted]
  ///
  /// Returns a unit if the case is give.
  String goalType(GoalType type) {
    if (type == GoalType.Weighted) {
      return 'kg';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalData = Provider.of<Goals>(context, listen: false);
    final goalTet = Provider.of<GoalItem>(context, listen: false);
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
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
                goal.imageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  goalData.deleteGoal(goal.id);
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
                    goalTet.finishGoal(goal.id);
                    goalData.notifyGoals();
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
                  child: CircularPercentIndicator(
                    radius: 100,
                    percent: 0.7,
                    progressColor: Colors.blue[400],
                    center: Text(
                      '70%',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                '${goal.current.toString()} ${goalType(goal.type)}',
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
                                '${(goal.target - goal.current).toString()} ${goalType(goal.type)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Left'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${goal.target.toString()} ${goalType(goal.type)}',
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => showSlidesheet(goal.id),
                        child: Text(
                          'Edit Goal',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
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
                            '${goal.interval} weeks',
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
    );
  }
}
