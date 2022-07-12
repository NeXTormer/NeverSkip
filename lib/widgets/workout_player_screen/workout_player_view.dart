import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/screens/workout_player_screen.dart';

import 'activity_player_view.dart';

class WorkoutPlayerView extends StatefulWidget {
  const WorkoutPlayerView(
      {required this.changeView,
      required this.constraints,
      required this.activities,
      Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;
  final BoxConstraints constraints;
  final void Function(WorkoutPlayerViewType) changeView;

  @override
  _WorkoutPlayerViewState createState() => _WorkoutPlayerViewState();
}

class _WorkoutPlayerViewState extends State<WorkoutPlayerView> {
  PageController pageController = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    int numberOfActivities = widget.activities.length;
    return PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: numberOfActivities,
        itemBuilder: (context, index) {
          return ActivityPlayerView(
            widget.activities[index],
            onTapEnd: () => widget.changeView(WorkoutPlayerViewType.End),
            nextActivity: index + 1 == (numberOfActivities)
                ? null
                : widget.activities[index + 1],
            constraints: widget.constraints,
            pageController: pageController,
            showSmartSuggestions: false,
          );
        });
  }

  void showEndView() {}
}
