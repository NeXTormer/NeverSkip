import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/activity_screen.dart';
import 'package:frederic/widgets/activity_screen/activity_card.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';

class EditWorkoutScreen extends StatefulWidget {
  EditWorkoutScreen(this.workout);

  static const routeName = '/workout';
  final FredericWorkout workout;

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  bool _test = false;

  TextEditingController titleTextController;
  PageController activityPageController;
  WeekdaySliderController sliderController;

  int selectedDay = 1;

  @override
  void initState() {
    sliderController =
        WeekdaySliderController(onDayChange: handleDayChangeByButton);
    activityPageController = PageController();
    titleTextController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _tempTitle = widget.workout.name;
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Material(
            type: MaterialType.transparency,
            child: _test
                ? TextFormField(
                    controller: titleTextController..text = _tempTitle,
                    onFieldSubmitted: (value) {
                      setState(() {
                        _test = false;
                        widget.workout.name = value;
                        _tempTitle = value;
                      });
                    },
                  )
                : Text(
                    _tempTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.edit_outlined, size: 30),
                onPressed: () {
                  print('edit workout details');
                  setState(() {
                    _test = !_test;
                  });
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
                    controller: sliderController,
                    onSelectDay: null,
                    weekCount: 2,
                  )
                ],
              ),
            ),
            StreamBuilder<FredericWorkout>(
                stream: widget.workout.asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Expanded(
                      child: PageView(
                          onPageChanged: handleDayChangeBySwiping,
                          controller: activityPageController,
                          children: List.generate(
                              snapshot.data.activities.period, (weekday) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return ActivityCard(
                                  snapshot.data.activities
                                      .activities[weekday + 1][index],
                                  dismissable: true,
                                  onDismiss: handleDeleteActivity,
                                  key: Key(
                                    getRandomString(16),
                                  ),
                                );
                              },
                              itemCount: snapshot.data.activities
                                  .activities[weekday + 1].length,
                            );
                          })),
                    );
                  return CircularProgressIndicator();
                }),
          ],
        ));
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void handleAddActivity(FredericActivity activity) {
    widget.workout.addActivity(activity, sliderController.currentDay);
    print('currentday: ${sliderController.currentDay}');
  }

  void handleDeleteActivity(FredericActivity activity) {
    widget.workout.removeActivity(activity, sliderController.currentDay);
  }

  void handleDayChangeByButton(int day) {
    if ((day - 1 - activityPageController.page).abs() <= 2)
      activityPageController.animateToPage(day - 1,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOutExpo);
    else
      activityPageController.jumpToPage(day - 1);
  }

  void handleDayChangeBySwiping(int day) {
    sliderController.setDayOnlyVisual(day + 1);
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
