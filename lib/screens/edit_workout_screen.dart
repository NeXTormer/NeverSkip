import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_activity_list_segment.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_header.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider_segment.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';
import 'package:google_fonts/google_fonts.dart';

///
/// Screen create/edit individual workouts
///
class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workoutID);

  static const routeName = '/workout';
  final String workoutID;

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  PageController? activityPageController;
  WeekdaySliderController? sliderController;

  int selectedDay = 1;

  @override
  void initState() {
    sliderController =
        WeekdaySliderController(onDayChange: handleDayChangeByButton);
    activityPageController = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return FredericWorkoutBuilder(
      id: widget.workoutID,
      builder: (context, data) {
        FredericWorkout workout = data;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                EditWorkoutHeader(),
                Divider(color: const Color(0xFFC9C9C9)),
                WeekdaysSliderSegment(workout, sliderController),
                Divider(color: const Color(0xFFC9C9C9)),
                EditActivityListSegment(
                    workout, sliderController, activityPageController),
              ],
            ),
          ),
          floatingActionButton:
              workout.canEdit! ? buildAddExerciseButton(width, 44) : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  // TODO maybe add to Standard Element
  Widget buildAddExerciseButton(double width, double height) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FloatingActionButton(
        elevation: 0,
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
    bool success = FredericBackend.instance()!
            .workoutManager![widget.workoutID]
            ?.addActivity(activity, sliderController!.currentDay) ??
        false;

    if (success) {
      UserFeedbackToast().showAddedToast(context);
    }
  }

  void handleDeleteActivity(FredericActivity activity) {
    FredericBackend.instance()!
        .workoutManager![widget.workoutID]
        ?.removeActivity(activity, sliderController!.currentDay);
  }

  void handleDayChangeByButton(int day) {
    if ((day - 1 - activityPageController!.page!).abs() <= 2)
      activityPageController!.animateToPage(day - 1,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOutExpo);
    else
      activityPageController!.jumpToPage(day - 1);
  }

  void showActivityList(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          // TODO SET ActivityListScreen backgroundcolor to transparent
          child: ActivityListScreen(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
