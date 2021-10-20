import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/edit_workout_activity_card.dart';

///
/// Part of the EditWorkoutScreen. Responsible for
/// displaying the user's added activities
///
class EditWorkoutActivityListSegment extends StatefulWidget {
  EditWorkoutActivityListSegment(
      {required this.workout,
      required this.pageController,
      required this.weekdaysSliderController});

  final FredericWorkout workout;
  final PageController pageController;
  final WeekdaysSliderController weekdaysSliderController;

  @override
  State<EditWorkoutActivityListSegment> createState() =>
      _EditWorkoutActivityListSegmentState();
}

class _EditWorkoutActivityListSegmentState
    extends State<EditWorkoutActivityListSegment> {
  bool currentlyDragging = false;

  FredericActivity? latestDeletion;

  @override
  Widget build(BuildContext context) {
    bool workoutIsEditable = widget.workout.canEdit;
    return Expanded(
      child: PageView(
          onPageChanged: (index) {
            widget.weekdaysSliderController.onChangeCallback(index);
          },
          controller: widget.pageController,
          children: List.generate(widget.workout.period * 7, (weekday) {
            int activityCount =
                widget.workout.activities.activities[weekday + 1].length;
            return CupertinoScrollbar(
                child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: ReorderableListView.builder(
                  proxyDecorator: _proxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                    currentlyDragging = false;
                    if (workoutIsEditable) {
                      widget.workout.changeOrderOfActivity(
                          weekday + 1, oldIndex, newIndex);
                    }
                  },
                  itemCount: activityCount,
                  itemBuilder: (context, index) {
                    FredericWorkoutActivity activity = widget
                        .workout.activities.activities[weekday + 1][index];
                    return EditWorkoutActivityCard(activity,
                        margin: const EdgeInsets.only(bottom: 16),
                        workout: widget.workout,
                        editable: workoutIsEditable,
                        key: ValueKey(activity), onDelete: () {
                      widget.workout.removeActivity(activity, weekday + 1);
                      latestDeletion = activity.activity;
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 4, left: 16, right: 16),
                        dismissDirection: DismissDirection.down,
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 16, right: 16),
                        content: Text(
                          'Activity removed from workout.',
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        action: SnackBarAction(
                          textColor: Colors.white,
                          label: 'Undo',
                          onPressed: () {
                            if (latestDeletion != null) {
                              FredericBackend.instance.workoutManager.state
                                  .workouts[widget.workout.workoutID]
                                  ?.addActivity(FredericWorkoutActivity(
                                      activity: latestDeletion!,
                                      weekday: weekday + 1));
                            }
                          },
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12))),
                        backgroundColor: theme.mainColor,
                      ));
                    });
                  }),
            ));
          })),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    if (!currentlyDragging) {
      HapticFeedback.selectionClick();
      currentlyDragging = true;
    }
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 0,
      color: Colors.transparent,
      child: child,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 1, animValue)!;
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: child,
          elevation: 1,
        );
      },
      child: child,
    );
  }
}
