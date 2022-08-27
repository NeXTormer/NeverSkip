import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/state/workout_player_state.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:provider/provider.dart';

class WorkoutPlayerEndView extends StatelessWidget {
  const WorkoutPlayerEndView(
      {required this.activities, required this.constraints, Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutPlayerState>(builder: (context, state, child) {
      return Container(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FredericHeading(
              'Good Job!',
              fontSize: 20,
            ),
            SizedBox(height: 4),
            Text(
              'You completed your workout for today.',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 24),
            FredericHeading('Statistics'),
            SizedBox(height: 4),
            Text('Your workout took ${state.getCurrentTimeFancy()}.'),
            SizedBox(height: 32),
            Expanded(child: Container()),
            FredericButton('Done', onPressed: () {
              Navigator.of(context).pop();
            })
          ],
        ),
      ));
    });
  }
}
