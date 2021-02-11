import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/providers/activity.dart';
import 'package:frederic/providers/workout_edit.dart';
import 'package:frederic/widget/second_design/activity/activity_card.dart';
import 'package:frederic/widget/second_design/appbar/activity_flexiable_appbar.dart';
import 'package:frederic/widget/second_design/calendar/week_days_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class EditWorkoutScreen extends StatefulWidget {
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
                      background: ActivityFlexiableAppbar(),
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
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Expanded(
            child: TextField(
              cursorColor: Theme.of(context).cursorColor,
              style: TextStyle(fontSize: 24),
              decoration: InputDecoration(
                hintText: 'Title',
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.black54,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              controller: _titleTextController,
            ),
          ),
          actions: [
            FlatButton.icon(
              onPressed: () => _showModalBottomSheet(context, activities),
              icon: Icon(Icons.add, size: 40),
              label: Text('Add'),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
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
                      (index) => WeekDaysSlide(
                          index, _updateSelectedDay, _selectedDay),
                    ),
                  ),
                ],
              ),
            ),
            if (workoutDayList != null)
              Container(
                height: 400,
                child: ListView.builder(
                    itemCount: workoutDayList.length,
                    itemBuilder: (ctx, index) {
                      return ActivityCard(workoutDayList[index], null, null);
                    }),
              )
          ],
        ),
      ),
    );
  }
}
