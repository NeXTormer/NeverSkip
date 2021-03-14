import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/profile_screen/goal/edit_goal_view.dart';
import 'package:intl/intl.dart';

enum Mode {
  GOAL,
  ACHIEVEMENT,
  EDIT,
}

class FinishGoalView extends StatelessWidget {
  FinishGoalView(this.goal, this.mode);
  final Mode mode;
  final FredericGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO Animate slide in
      // padding: EdgeInsets.only(top: x),
      child: mode == Mode.EDIT
          ? EditGoalView()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageSection(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${goal.title}',
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.fitness_center,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      Text(
                        'Started: ${DateFormat('dd.MM.yyyy').format(goal.startDate)}',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Divider(thickness: 0.8),
                      _buildDataSection(context),
                    ],
                  ),
                ),
                _buildButtonUserInteractionSection(context),
              ],
            ),
    );
  }

  _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Image.network(
        goal.image,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  _buildDataSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDataColText(goal.startState.toString(), 'Start'),
              _buildVerticalDivider(color: Colors.black26),
              _buildDataColText(goal.currentState.toString(), 'Current'),
              _buildVerticalDivider(color: Colors.black26),
              _buildDataColText(goal.endState.toString(), 'Target'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'You finished your goal in 8 Weeks',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.timer,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildButtonUserInteractionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: mode == Mode.GOAL
            ? [
                _buildDialogButton('Discard', Colors.redAccent, () {
                  // TODO
                  // Discard Goal
                  Navigator.of(context).pop();
                }),
                SizedBox(width: 10),
                _buildDialogButton('Save & Continue', Colors.lightBlue, () {
                  // TODO
                  // Save to Achievements
                  Navigator.of(context).pop();
                }),
              ]
            : [
                _buildDialogButton('Remove', Colors.redAccent, () {
                  // TODO
                  // Remove goal from achievements
                  print('remove');
                })
              ],
      ),
    );
  }

  _buildDialogButton(String text, Color color, Function onTap) {
    return InkWell(
      onTap: onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _buildVerticalDivider({double width = 0.5, Color color = Colors.black45}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: width,
            color: color,
          ),
        ),
      ),
    );
  }

  _buildDataColText(String data, String title) {
    return Column(
      children: [
        Text(
          data,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
