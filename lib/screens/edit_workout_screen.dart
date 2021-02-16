import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/activity_screen.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';

class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workout);

  static const routeName = '/workout';
  final FredericWorkout workout;
  final int numberOfWeeks = 2;
  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final titleTextController = TextEditingController();
  int selectedDay = 1;

  WeekdaySliderController sliderController;

  @override
  void initState() {
    sliderController = WeekdaySliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Hero(
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                widget.workout.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            tag: widget.workout.name,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.edit_outlined, size: 30),
                onPressed: () {
                  print('edit workout details');
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showActivityList(context),
          backgroundColor: Colors.orange,
          splashColor: Colors.orangeAccent,
          child: Icon(Icons.add, size: 36),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Container(
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    left: 0.0,
                    child: Icon(
                      Icons.arrow_left,
                      size: 36,
                      color: Colors.black26,
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: Icon(
                      Icons.arrow_right,
                      size: 36,
                      color: Colors.black26,
                    ),
                  ),
                  WeekdaysSlider(
                    controller: null,
                    onSelectDay: null,
                    weekCount: 2,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  void handleAddActivity(FredericActivity activity) {
    print('add activity ${activity.name}');
  }

  void showActivityList(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ActivityScreen(
              isSelector: true,
              onAddActivity: handleAddActivity,
              itemsDismissable: false,
            ));
      },
    );
  }

  @override
  void dispose() {
    titleTextController.dispose();
    super.dispose();
  }
}
