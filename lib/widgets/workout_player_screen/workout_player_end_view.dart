import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';

class WorkoutPlayerEndView extends StatelessWidget {
  const WorkoutPlayerEndView(
      {required this.activities, required this.constraints, Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('End'),
    ));
  }
}
