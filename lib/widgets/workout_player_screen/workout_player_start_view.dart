import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';

class WorkoutPlayerStartView extends StatelessWidget {
  const WorkoutPlayerStartView(
      {required this.activities,
      required this.constraints,
      required this.pageController,
      Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;
  final PageController pageController;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
