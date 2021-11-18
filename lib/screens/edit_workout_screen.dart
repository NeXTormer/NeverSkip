import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_activity_list_segment.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_header.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

///
/// Screen create/edit individual workouts
///
class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workoutID, {this.defaultPage = 0}) {
    FredericBackend.instance.analytics.analytics
        .setCurrentScreen(screenName: 'edit-workout-screen');
  }

  final String workoutID;
  final int defaultPage;

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late PageController pageController;
  late WeekdaysSliderController weekdaysSliderController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.defaultPage);
    weekdaysSliderController = WeekdaysSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return FredericScaffold(
      body: BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
        builder: (context, workoutListData) {
          FredericWorkout? workout = workoutListData.workouts[widget.workoutID];
          if (workout == null) {
            Navigator.of(context).pop();
            print('Workout not found');
            return Container();
          }
          return FredericScaffold(
            floatingActionButton: workout.canEdit
                ? buildAlternativeAddExerciseButton(width, 44)
                : null,
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            body: Column(
              children: [
                EditWorkoutHeader(workout),
                if (theme.isBright) SizedBox(height: 8),
                if (theme.isBright) FredericDivider(),
                SizedBox(height: 8),
                WeekdaysSliderSegment(
                    defaultSelectedIndex: widget.defaultPage,
                    pageController: pageController,
                    weekdaysSliderController: weekdaysSliderController,
                    workout: workout),
                SizedBox(height: 8),
                FredericDivider(),
                //SizedBox(height: 8),
                EditWorkoutActivityListSegment(
                    workout: workout,
                    pageController: pageController,
                    weekdaysSliderController: weekdaysSliderController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildAlternativeAddExerciseButton(double width, double height) {
    return FloatingActionButton(
      backgroundColor: theme.mainColor,
      onPressed: () => showActivityList(context),
      child: Icon(
        Icons.post_add_outlined,
        color: theme.textColorColorfulBackground,
      ),
    );
  }

  Widget buildAddExerciseButton(double width, double height) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: theme.mainColor,
        onPressed: () => showActivityList(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Text(
          'Add Exercise',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void handleAddActivity(FredericActivity activity) {
    bool success = FredericBackend
            .instance.workoutManager.state.workouts[widget.workoutID]
            ?.addActivity(FredericWorkoutActivity(
                activity: activity,
                weekday: pageController.page!.toInt() + 1)) ??
        false;

    if (success) {
      UserFeedbackToast().showAddedToast(context);
    }
  }

  void showActivityList(BuildContext context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          //height: MediaQuery.of(ctx).size.height * 0.8,
          child: ActivityListScreen(
            isSelector: true,
            onSelect: (activity) {
              handleAddActivity(activity);
              Navigator.of(ctx).pop();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

class WeekdaysSliderController {
  WeekdaysSliderController();
  late Function(int) _setChangeDayCallback;

  void setCallback(Function(int) handleChangeDay) {
    _setChangeDayCallback = handleChangeDay;
  }

  void onChangeCallback(int index) {
    _setChangeDayCallback(index);
  }
}
