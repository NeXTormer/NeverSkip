import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/edit_workout_activity_card.dart';

///
/// Part of the EditWorkoutScreen. Responsible for
/// displaying the user's added activities
///
class EditWorkoutActivityListSegment extends StatelessWidget {
  EditWorkoutActivityListSegment(
      {required this.workout,
      required this.pageController,
      required this.weekdaysSliderController});

  final FredericWorkout workout;
  final PageController pageController;
  final WeekdaysSliderController weekdaysSliderController;

  @override
  Widget build(BuildContext context) {
    bool workoutIsEditable = workout.canEdit;
    return Expanded(
      child: PageView(
          onPageChanged: (index) {
            weekdaysSliderController.onChangeCallback(index);
          },
          controller: pageController,
          children: List.generate(workout.period * 7, (weekday) {
            int activityCount =
                workout.activities.activities[weekday + 1].length;
            return CupertinoScrollbar(
                child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: ReorderableListView.builder(
                  proxyDecorator: _proxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                    if (workoutIsEditable) {
                      int oldIndexAdapted = (oldIndex ~/ 2);
                      int newIndexAdapted = (newIndex ~/ 2);
                      if (newIndexAdapted >= activityCount)
                        newIndexAdapted = activityCount - 1;
                      if (oldIndexAdapted >= activityCount)
                        oldIndexAdapted = activityCount - 1;
                      workout.switchActivities(
                          weekday + 1, oldIndexAdapted, newIndexAdapted);
                    }
                  },
                  itemCount: activityCount * 2,
                  itemBuilder: (context, index) {
                    if (index % 2 == 1) {
                      return Container(height: 16, key: UniqueKey());
                    }

                    FredericWorkoutActivity activity =
                        workout.activities.activities[weekday + 1][index ~/ 2];
                    return EditWorkoutActivityCard(activity,
                        workout: workout,
                        editable: workoutIsEditable,
                        key: ValueKey(activity), onDelete: () {
                      workout.removeActivity(activity, weekday + 1);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 4),
                        elevation: 0,
                        content: Text(
                          'Activity removed from workout.',
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        action: SnackBarAction(
                          textColor: Colors.white,
                          label: 'Undo',
                          onPressed: () {},
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        backgroundColor: kMainColor,
                      ));
                    });
                  }),
            ));
          })),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 0, animValue)!;
        return Material(
          borderRadius: BorderRadius.circular(8),
          child: child,
          elevation: elevation,
        );
      },
      child: child,
    );
  }
}
