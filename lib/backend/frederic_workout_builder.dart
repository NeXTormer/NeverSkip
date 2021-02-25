import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';

import 'backend.dart';

///
/// Similar to a StreamBuilder, meaning that it provides the latest data for one
/// or many [FredericWorkout]s.
/// If an [id] is provided, the builder returns a single
/// [FredericWorkout].
/// If no [id] is provided, the builder returns a [List<FredericWorkout>]
///
class FredericWorkoutBuilder extends StatefulWidget {
  FredericWorkoutBuilder({this.id, @required this.builder});

  final String id;
  final Widget Function(BuildContext, dynamic) builder;

  @override
  _FredericWorkoutBuilderState createState() => _FredericWorkoutBuilderState();
}

class _FredericWorkoutBuilderState extends State<FredericWorkoutBuilder> {
  FredericWorkoutManager _workoutManager;

  List<FredericWorkout> _workoutList;
  FredericWorkout _workout;
  bool _singleWorkout;

  @override
  void initState() {
    _workoutManager = FredericBackend.instance().workoutManager;
    _singleWorkout = widget.id != null;
    super.initState();
    _workoutManager.addListener(updateData);
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _singleWorkout ? _workout : _workoutList);
  }

  void updateData() {
    setState(() {
      if (_singleWorkout) {
        _workout = _workoutManager[widget.id];
      } else {
        _workoutList = _workoutManager.workouts.values.toList();
      }
    });
  }

  @override
  void dispose() {
    _workoutManager.removeListener(updateData);
    super.dispose();
  }
}
