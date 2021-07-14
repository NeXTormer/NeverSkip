import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';

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
  final PageController pageController;
  final WeekdaysSliderController weekdaysSliderController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
          onPageChanged: (index) {
            weekdaysSliderController.onChangeCallback(index);
          },
          controller: pageController,
          children: List.generate(workout.period * 7, (weekday) {
            return CupertinoScrollbar(
                child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount:
                        workout.activities.activities[weekday + 1].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        child: ActivityCard(
                            workout.activities.activities[weekday + 1][index],
                            type: ActivityCardType.WorkoutEditor, onClick: () {
                          workout.removeActivity(
                              workout.activities.activities[weekday + 1][index],
                              weekday + 1);
                        }),
                      );
                    }));
          })),
    );
  }
}
