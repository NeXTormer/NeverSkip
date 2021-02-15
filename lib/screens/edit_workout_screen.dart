import 'package:flutter/material.dart';
import 'package:frederic/providers/activity.dart';
import 'package:frederic/providers/workout_edit.dart';
import 'package:frederic/widgets/activity_screen/appbar/activity_flexiable_appbar.dart';
import 'package:frederic/widgets/second_design/activity/activity_card.dart';
import 'package:frederic/widgets/second_design/calendar/week_days_slider.dart';
import 'package:provider/provider.dart';

class EditWorkoutScreen extends StatefulWidget {
  static const routeName = '/workout';
  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _controller = PageController(viewportFraction: 1.0);
  var _selectedDay = 1;
  final _titleTextController = TextEditingController();

  @override
  void initState() {
    _titleTextController.addListener(_printTitleText);
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    super.dispose();
  }

  _printTitleText() {
    print(_titleTextController.text);
  }

  void _updateSelectedDay(int newDay) {
    setState(() {
      _selectedDay = newDay;
    });
  }

  void _addActivityToDay(int day, ActivityItem activityItem) {
    print('-----' + activityItem.name);
    setState(() {
      final workoutEdit = Provider.of<WorkoutEdit>(context, listen: false)
          .addActivityToDay(day, activityItem);
    });
  }

  void _showModalBottomSheet(
      BuildContext context, List<ActivityItem> activities) {
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
        return Wrap(
          children: [
            Container(
              height: 800,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    title: Container(
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt),
                          Text(
                            'Activites',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: 150.0,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: ActivityFlexibleAppbar(),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, index) => ActivityCard(
                          activities[index], _addActivityToDay, _selectedDay),
                      childCount: activities.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutDayList =
        Provider.of<WorkoutEdit>(context).getListPerDay(_selectedDay);
    final List<ActivityItem> activities =
        Provider.of<Activity>(context, listen: false).independentActivities;

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
                  controller: _titleTextController,
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
              onPressed: () => _showModalBottomSheet(context, activities),
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
                  controller: _controller,
                  children: List.generate(
                    5,
                    (index) =>
                        WeekDaysSlide(index, _updateSelectedDay, _selectedDay),
                  ),
                ),
              ],
            ),
          ),
          if (workoutDayList != null)
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
            ),
        ],
      ),
    );
  }
}
