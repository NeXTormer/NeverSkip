import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/activity_screen.dart';
import 'package:frederic/widgets/second_design/calendar/week_days_slider.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: titleTextController,
                  autofocus: false,
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            FlatButton.icon(
              onPressed: () => showActivityList(context),
              icon: Icon(Icons.add, size: 30),
              label: Text(
                'Add',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
