import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';

class WorkoutWidget extends StatefulWidget {
  const WorkoutWidget({Key key, @required this.workout}) : super(key: key);

  final FredericWorkout workout;

  @override
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Text(widget.workout.name));
  }
}
