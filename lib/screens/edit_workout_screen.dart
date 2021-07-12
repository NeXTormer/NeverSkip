import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_header.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';
import 'package:google_fonts/google_fonts.dart';

class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workoutID);

  static const routeName = '/workout';
  final String workoutID;

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  static const double SIDE_PADDING = 16;

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
    return BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
      builder: (context, workoutListData) {
        FredericWorkout workout = workoutListData.workouts[widget.workoutID]!;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SIDE_PADDING),
              child: Column(
                children: [
                  EditWorkoutHeader(),
                  Divider(color: const Color(0xFFC9C9C9)),
                  WeekdaysSlider(
                    controller: sliderController,
                    onSelectDay: null,
                    weekCount: workout.period,
                  ),
                  Divider(color: const Color(0xFFC9C9C9)),
                ],
              ),
            ),
          ),
          floatingActionButton:
              workout.canEdit! ? buildAddExerciseButton(width) : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return FredericWorkoutBuilder(
        id: widget.workoutID,
        builder: (context, data) {
          FredericWorkout workout = data;
          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: workout.canEdit!
                  ? FloatingActionButton(
                      onPressed: () => showActivityList(context),
                      backgroundColor: kMainColor,
                      splashColor: kAccentColor,
                      child: Icon(Icons.add, size: 36),
                    )
                  : null,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: Column(
                children: [
                  Container(
                    height: 100,
                    child: Stack(
                      children: [
                        Container(
                          child: WeekdaysSlider(
                            controller: sliderController,
                            onSelectDay: null,
                            weekCount: workout.period,
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          child: GestureDetector(
                            onTap: () {
                              sliderController!.pageController!.previousPage(
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOutExpo);
                            },
                            child: Icon(
                              Icons.arrow_left,
                              size: 36,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          child: GestureDetector(
                            onTap: () {
                              sliderController!.pageController!.nextPage(
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOutExpo);
                            },
                            child: Icon(
                              Icons.arrow_right,
                              size: 36,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: FredericActivityBuilder(
                  //       type: FredericActivityBuilderType.WorkoutActivities,
                  //       id: workout.workoutID,
                  //       builder: (context, list) {
                  //         FredericWorkoutActivities activities = list;
                  //         return PageView(
                  //             physics: BouncingScrollPhysics(),
                  //             onPageChanged: handleDayChangeBySwiping,
                  //             controller: activityPageController,
                  //             children:
                  //                 List.generate(activities.period, (weekday) {
                  //               return CupertinoScrollbar(
                  //                 child: ListView.builder(
                  //                   padding: EdgeInsets.only(top: 8),
                  //                   itemBuilder: (context, index) {
                  //                     return Container();
                  //
                  //                     // return ActivityCard(
                  //                     //   activities.activities[weekday + 1]
                  //                     //       [index],
                  //                     //   dismissible: workout.canEdit,
                  //                     //   onDismiss: handleDeleteActivity,
                  //                     // );
                  //                   },
                  //                   itemCount: activities
                  //                       .activities![weekday + 1].length,
                  //                 ),
                  //               );
                  //             }));
                  //       }),
                  // ),
                ],
              ));
        });
  }*/

  Widget buildAddExerciseButton(double width) {
    return Container(
      height: 44,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: kMainColor,
        onPressed: () => {}, //showActivityList(context),
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
    bool success = FredericBackend.instance.workoutManager![widget.workoutID]
            ?.addActivity(activity, sliderController!.currentDay) ??
        false;

    if (success) {
      UserFeedbackToast().showAddedToast(context);
    }
  }

  void handleDeleteActivity(FredericActivity activity) {
    FredericBackend.instance.workoutManager![widget.workoutID]
        ?.removeActivity(activity, sliderController!.currentDay);
  }

  void handleDayChangeByButton(int day) {
    if ((day - 1 - activityPageController!.page!).abs() <= 2)
      activityPageController!.animateToPage(day - 1,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOutExpo);
    else
      activityPageController!.jumpToPage(day - 1);
  }

  void handleDayChangeBySwiping(int day) {
    sliderController!.setDayOnlyVisual(day + 1);
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
            height: MediaQuery.of(context).size.height * 0.65,
            child: Container()
            // ActivityScreen(
            //   isSelector: true,
            //   onAddActivity: handleAddActivity,
            //   itemsDismissable: false,
            // )
            );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
