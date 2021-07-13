import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/edit_workout_screen.dart';

///
/// Part of the EditWorkoutScreen. Responsible for
/// displaying the user's added activities
///
class EditActivityListSegment extends StatelessWidget {
  EditActivityListSegment(
      {required this.workout,
      required this.pageController,
      required this.weekdaysSliderController});

  final FredericWorkout workout;
  final PageController? pageController;
  final WeekdaysSliderController? weekdaysSliderController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FredericActivityBuilder(
          type: FredericActivityBuilderType.WorkoutActivities,
          id: workout.workoutID,
          builder: (context, list) {
            FredericWorkoutActivities activities = list;
            return PageView(
                onPageChanged: (index) {
                  weekdaysSliderController!.onChangeCallback(index);
                },
                controller: pageController,
                children: List.generate(activities.period, (weekday) {
                  return CupertinoScrollbar(
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: activities.activities![weekday + 1].length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              color: Colors.black26,
                              width: 100,
                              height: 100,
                            );
                            // ActivityListCard(
                            //     activities.activities![weekday + 1][index]!);
                          }));
                }));
          }),
    );
  }
}
