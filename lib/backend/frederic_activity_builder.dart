import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';

///
/// Use this to display one or more activities. When the underlying data changes
/// the [builder] method is called again with the new data.
///
/// the [builder] method has two parameters: BuildContext and dynamic.
/// dynamic is either FredericActivity, FredericWorkoutActivities, or List<FredericActivity>,
/// depending on the [FredericActivityBuilderType]
/// - [FredericActivity]
///     -> returns a single activity with the id [id]
/// - [FredericWorkoutActivities]
///     -> returns the [FredericWorkoutActivities] for the workout with the id [id]
/// - [List<FredericActivity>]
///     -> returns a list of all activities the user has access to. Does not need
///     an id
///
class FredericActivityBuilder extends StatefulWidget {
  FredericActivityBuilder(
      {Key? key, required this.type, required this.builder, this.id})
      : super(key: key);

  final String? id;
  final FredericActivityBuilderType type;

  final Widget Function(BuildContext, dynamic) builder;

  @override
  _FredericActivityBuilderState createState() =>
      _FredericActivityBuilderState();
}

class _FredericActivityBuilderState extends State<FredericActivityBuilder> {
  List<FredericActivity>? _activityList;
  FredericWorkoutActivities? _fredericWorkoutActivities;
  FredericActivity? _activity;

  FredericActivityManager? _activityManager;
  FredericWorkoutManager? _workoutManager;

  @override
  void initState() {
    _activityManager = FredericBackend.instance!.activityManager;
    if (widget.type == FredericActivityBuilderType.SingleActivity) {
      _activityManager![widget.id]?.addListener(updateData);
    } else {
      _activityManager!.addListener(updateData);
      if (widget.type == FredericActivityBuilderType.WorkoutActivities) {
        _workoutManager = FredericBackend.instance!.workoutManager;
        _workoutManager![widget.id]?.loadActivities();
        _workoutManager![widget.id]
            ?.addListener(updateData); //TODO add null safety
        _workoutManager?.addListener(updateData);
      }
    }
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case FredericActivityBuilderType.WorkoutActivities:
        return widget.builder(context, _fredericWorkoutActivities);
      case FredericActivityBuilderType.SingleActivity:
        return widget.builder(context, _activity);
      case FredericActivityBuilderType.AllActivities:
        return widget.builder(context, _activityList);
      default:
        return Text(
            '[FActivityBuilder] You need to enter an activitybuildertype');
    }
  }

  void updateData() {
    setState(() {
      switch (widget.type) {
        case FredericActivityBuilderType.WorkoutActivities:
          _fredericWorkoutActivities = _workoutManager![widget.id]?.activities;
          break;
        case FredericActivityBuilderType.SingleActivity:
          _activity = _activityManager![widget.id];
          break;
        case FredericActivityBuilderType.AllActivities:
          _activityList = _activityManager!.activities.toList();
          break;
      }
    });
  }

  @override
  void dispose() {
    if (_workoutManager != null) {
      _workoutManager!.removeListener(updateData);
      _workoutManager![widget.id]?.removeListener(updateData);
    }
    _activityManager!.removeListener(updateData);
    if (widget.type == FredericActivityBuilderType.SingleActivity)
      _activityManager![widget.id]?.removeListener(updateData);
    super.dispose();
  }
}

enum FredericActivityBuilderType {
  WorkoutActivities,
  SingleActivity,
  AllActivities
}
