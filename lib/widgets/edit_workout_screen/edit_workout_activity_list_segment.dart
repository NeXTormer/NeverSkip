import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';

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
    return Expanded(
      child: PageView(
          onPageChanged: (index) {
            weekdaysSliderController.onChangeCallback(index);
          },
          controller: pageController,
          children: List.generate(workout.period * 7, (weekday) {
            return CupertinoScrollbar(
                child: ReorderableListView.builder(
                    onReorder: (oldIndex, newIndex) {},
                    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                    itemCount: () {
                      int numberOfItems =
                          workout.activities.activities[weekday + 1].length;
                      if (numberOfItems == 0) return 0;
                      return numberOfItems * 2;
                    }(),
                    itemBuilder: (context, index) {
                      if (index % 2 == 1) {
                        return Container(height: 16, key: ValueKey(index));
                      }
                      FredericActivity activity = workout
                          .activities.activities[weekday + 1][index ~/ 2];
                      return ActivityCard(activity,
                          key: ValueKey<String>(activity.activityID),
                          type: ActivityCardType.WorkoutEditor, onClick: () {
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
                    }));
          })),
    );
  }
}
