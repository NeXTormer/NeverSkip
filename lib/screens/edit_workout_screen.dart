import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_activity_list_segment.dart';
import 'package:frederic/widgets/edit_workout_screen/edit_workout_header.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';

///
/// Screen create/edit individual workouts
///
class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workoutID, {this.defaultPage = 0}) {
    FredericBackend.instance.analytics.logCurrentScreen('edit_workout_screen');
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
            return Container();
          }
          return FredericScaffold(
            floatingActionButton: workout.canEdit
                ? FloatingActionButton(
                    // This seems to have fixed itself without a key and hero tag
                    // key: UniqueKey(),
                    // heroTag: UniqueKey(),
                    // because the FAB disappears after resulting sheet is closed,
                    // the unique key combined with the setState after the sheet is closed makes it reappear
                    backgroundColor: theme.mainColor,
                    onPressed: () => showActivityList(context),
                    child: Icon(
                      Icons.post_add_outlined,
                      color: Colors.white,
                    ),
                  )
                : null,
            body: Column(
              children: [
                EditWorkoutHeader(workout),
                if (theme.isMonotone) SizedBox(height: 8),
                if (theme.isMonotone) FredericDivider(),
                SizedBox(height: 8),
                WeekdaysSliderSegment(
                    defaultSelectedIndex: widget.defaultPage,
                    pageController: pageController,
                    weekdaysSliderController: weekdaysSliderController,
                    workout: workout),
                SizedBox(height: 8),
                FredericDivider(),
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

  void showActivityList(BuildContext context) async {
    await showFredericBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          // height: MediaQuery.of(ctx).size.height * 0.8,
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
    // calling setState to generate a new unique key for the FAB, to make it reappear
    setState(() {});
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
