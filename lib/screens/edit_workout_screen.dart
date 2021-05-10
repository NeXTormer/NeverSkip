import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity_builder.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';

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
    return FredericWorkoutBuilder(
        id: widget.workoutID,
        builder: (context, data) {
          FredericWorkout workout = data;
          if (workout?.name == null) return Container();
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
                  Expanded(
                    child: FredericActivityBuilder(
                        type: FredericActivityBuilderType.WorkoutActivities,
                        id: workout.workoutID,
                        builder: (context, list) {
                          FredericWorkoutActivities activities = list;
                          return PageView(
                              physics: BouncingScrollPhysics(),
                              onPageChanged: handleDayChangeBySwiping,
                              controller: activityPageController,
                              children:
                                  List.generate(activities.period, (weekday) {
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
                                    itemCount: activities
                                        .activities![weekday + 1].length,
                                  ),
                                );
                              }));
                        }),
                  ),
                ],
              ));
        });
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
