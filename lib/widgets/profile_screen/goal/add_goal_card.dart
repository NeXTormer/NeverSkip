import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/profile_screen/goal/finish_goal_view.dart';

///
/// A [GoalCard] which does not display a goal. Instead it has a button to add
/// a new goal.
///
class AddGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add new goal',
                  style: TextStyle(fontSize: 26, color: Colors.grey[800])),
              SizedBox(height: 12),
              InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            child: FinishGoalView(null, Mode.EDIT),
                            elevation: 10,
                            backgroundColor: Colors.transparent));
                  },
                  child: Icon(Icons.add_circle, color: kMainColor, size: 69))
            ],
          )),
    );
  }
}
