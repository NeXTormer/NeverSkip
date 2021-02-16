import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/activity_screen.dart';

import 'file:///C:/Dev/Projects/frederic/lib/widgets/calendar_screen/week_days_slider.dart';

class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workout);

  static const routeName = '/workout';
  final FredericWorkout workout;

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final controller = PageController(viewportFraction: 1.0);
  final titleTextController = TextEditingController();
  int selectedDay = 1;

  @override
  void initState() {
    //_titleTextController.addListener(_printTitleText);
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            height: 140,
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
                PageView(
                  controller: controller,
                  children: List.generate(
                    1,
                    (index) =>
                        WeekDaysSlide(index, _updateSelectedDay, selectedDay),
                  ),
                ),
              ],
            ),
          ),
          /*if (false || workoutDayList != null)
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: workoutDayList.length,
                  itemBuilder: (ctx, index) {
                    return ActivityCard(workoutDayList[index], null, null);
                  },
                ),
              ],
            ), */
        ],
      ),
    );
  }

  void _updateSelectedDay(int newDay) {
    setState(() {
      selectedDay = newDay;
    });
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
