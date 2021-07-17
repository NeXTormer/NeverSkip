import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_activity_list_segment.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_header.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider_segment.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

///
/// Screen create/edit individual workouts
///
class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workoutID);

  final String workoutID;

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late PageController pageController;
  late WeekdaysSliderController weekdaysSliderController;

  @override
  void initState() {
    pageController = PageController();
    weekdaysSliderController = WeekdaysSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
      builder: (context, workoutListData) {
        FredericWorkout workout = workoutListData.workouts[widget.workoutID]!;
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton:
              workout.canEdit ? buildAddExerciseButton(width, 44) : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: Column(
              children: [
                EditWorkoutHeader(workout),
                Divider(color: const Color(0xFFC9C9C9)),
                WeekdaysSliderSegment(
                    pageController: pageController,
                    weekdaysSliderController: weekdaysSliderController,
                    workout: workout),
                Divider(color: const Color(0xFFC9C9C9)),
                EditActivityListSegment(
                    workout: workout,
                    pageController: pageController,
                    weekdaysSliderController: weekdaysSliderController),
              ],
            ),
          ),
        );
      },
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
        backgroundColor: kMainColor,
        onPressed: () => showActivityList(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Text(
          'Add Exercise',
          style: GoogleFonts.montserrat(
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
            ?.addActivity(activity, pageController.page!.toInt() + 1) ??
        false;

    if (success) {
      UserFeedbackToast().showAddedToast(context);
    }
  }

  void handleDeleteActivity(FredericActivity activity) {
    FredericBackend.instance.workoutManager.state.workouts[widget.workoutID]
        ?.removeActivity(activity, pageController.page!.toInt());
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
