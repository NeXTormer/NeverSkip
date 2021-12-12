import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/screens/workout_player_screen.dart';

class WorkoutPlayerStartView extends StatelessWidget {
  const WorkoutPlayerStartView(
      {required this.activities,
      required this.constraints,
      required this.changeView,
      Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;
  final BoxConstraints constraints;
  final void Function(WorkoutPlayerViewType) changeView;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('Start'),
    ));
  }
}
