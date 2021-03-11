import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/profile_screen/goal/save_goal_buttons.dart';
import 'package:intl/intl.dart';

class FinishGoalView extends StatelessWidget {
  FinishGoalView(this.goal);
  final FredericGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO Animate slide in
      // padding: EdgeInsets.only(top: x),
      child: Column(
        children: [
          ClipRRect(
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
          ),
          Container(
            padding: const EdgeInsets.all(18),
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
                Divider(thickness: 1),
                _buildStatisticsTextBox(),
                SizedBox(height: 20),
                Row(
                  children: [
                    Spacer(),
                    SaveGoalButtons(goal),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildStatisticsTextBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.lightBlue[100],
        boxShadow: [
          const BoxShadow(
            color: Colors.black45,
          ),
          const BoxShadow(
            color: Colors.white,
            spreadRadius: 0,
            blurRadius: 5,
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: 'You started your jorney on the '),
            TextSpan(
              text: '${DateFormat('dd.MM.yyyy').format(goal.startDate)}\n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: 'It took you '),
            TextSpan(
              text:
                  '${DateTime.now().difference(goal.startDate).inDays} days\n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: 'To go from '),
            TextSpan(
              text: '${goal.startState} ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: 'to '),
            TextSpan(
              text: '${goal.currentState} ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: 'Reputations\n\n'),
            TextSpan(text: 'Keep Going!'),
          ],
        ),
      ),
    );
  }

  _buildSaveButton(String title, Function userChoice, Color color) {
    return FlatButton(
      //TODO Color Theme
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: color,
          width: 2,
        ),
      ),
      onPressed: () => userChoice(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: 100,
        child: AutoSizeText(
          title,
          style: TextStyle(color: color),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}
