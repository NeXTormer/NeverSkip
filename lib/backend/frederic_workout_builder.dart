import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';

import 'backend.dart';

///
/// Similar to a StreamBuilder, meaning that it provides the latest data for one
/// or many [FredericWorkout]s.
/// If [activeWorkouts] is provided, the builder returns a [List<FredericWorkout>]
/// which contains all active workouts
/// If an [id] is provided, the builder returns a single
/// [FredericWorkout].
/// If no [id] is provided, the builder returns a [List<FredericWorkout>]
///
class FredericWorkoutBuilder extends StatefulWidget {
  FredericWorkoutBuilder(
      {this.id, this.activeWorkouts, required this.builder}) {
    assert(!(this.id != null && this.activeWorkouts != null),
        'Workout ID and activeWorkouts cant be set at the same time');
  }

  final List<String>? activeWorkouts;
  final String? id;
  final Widget Function(BuildContext, dynamic) builder;

  @override
  _FredericWorkoutBuilderState createState() => _FredericWorkoutBuilderState();
}

class _FredericWorkoutBuilderState extends State<FredericWorkoutBuilder> {
  FredericWorkoutManager? _workoutManager;

  List<FredericWorkout?>? _workoutList;
  FredericWorkout? _workout;
  late bool _singleWorkout;
  late bool _selectedWorkouts;

  @override
  void initState() {
    _workoutManager = FredericBackend.instance()!.workoutManager;
    _singleWorkout = widget.id != null && widget.activeWorkouts == null;
    _selectedWorkouts = widget.activeWorkouts != null;
    super.initState();
    _workoutManager!.addListener(updateData);
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _singleWorkout ? _workout : _workoutList);
  }

  void updateData() {
    if (_selectedWorkouts) {
      for (String id in widget.activeWorkouts!) {
        var workout = _workoutManager!.workouts![id]!;
        if (!workout.hasActivitiesLoaded) workout.loadActivities();
      }
    }
    setState(() {
      if (_singleWorkout) {
        _workout = _workoutManager![widget.id];
      } else if (_selectedWorkouts) {
        _workoutList = <FredericWorkout?>[];
        for (String id in widget.activeWorkouts!) {
          _workoutList!.add(_workoutManager!.workouts![id]);
        }
      } else {
        _workoutList = _workoutManager!.workouts!.values.toList();
      }
    });
  }

  @override
  void dispose() {
    _workoutManager!.removeListener(updateData);
    super.dispose();
  }
}
