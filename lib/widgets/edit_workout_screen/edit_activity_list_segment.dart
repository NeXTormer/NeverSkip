import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';

///
/// Part of the EditWorkoutScreen. Responsible for
/// displaying the user's added activities
///
class EditActivityListSegment extends StatelessWidget {
  EditActivityListSegment(
      this.workout, this.sliderController, this.activityPageController);

  final FredericWorkout workout;
  final PageController? activityPageController;
  final WeekdaySliderController? sliderController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FredericActivityBuilder(
          type: FredericActivityBuilderType.WorkoutActivities,
          id: workout.workoutID,
          builder: (context, list) {
            FredericWorkoutActivities activities = list;
            return PageView(
                physics: BouncingScrollPhysics(),
                onPageChanged: handleDayChangeBySwiping,
                controller: activityPageController,
                children: List.generate(activities.period, (weekday) {
                  return CupertinoScrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 8),
                      itemBuilder: (context, index) {
                        return Container();

                        // return ActivityCard(
                        //   activities.activities[weekday + 1]
                        //       [index],
                        //   dismissible: workout.canEdit,
                        //   onDismiss: handleDeleteActivity,
                        // );
                      },
                      itemCount: activities.activities![weekday + 1].length,
                    ),
                  );
                }));
          }),
    );
  }

  void handleDayChangeBySwiping(int day) {
    sliderController!.setDayOnlyVisual(day + 1);
  }
}
