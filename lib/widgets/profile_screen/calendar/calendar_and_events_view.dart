import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/backend/frederic_user.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widget/second_design/activity/activity_in_workout.dart';
import 'package:frederic/widgets/calendar_screen/calendar_workout_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAndEventsView extends StatefulWidget {
  @override
  _CalendarAndEventsViewState createState() => _CalendarAndEventsViewState();
}

class _CalendarAndEventsViewState extends State<CalendarAndEventsView> {
  Map<DateTime, List<dynamic>> _events;
  List<FredericActivity> _selectedEvents = [];
  AnimationController _animationController;
  CalendarController _calendarController;
  FredericUser user = FredericUser(FirebaseAuth.instance.currentUser.uid);
  int _selectedDate = 0;

  @override
  void initState() {
    _calendarController = CalendarController();
    _events = {};
    initWorkout();
    super.initState();
  }

  initWorkout() async {}

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  _onDaySelected(DateTime day, List events, List _) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDate = day.weekday;
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          child: TableCalendar(
            events: _events,
            initialCalendarFormat: CalendarFormat.week,
            calendarController: _calendarController,
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: _onDaySelected,
            builders: CalendarBuilders(
                todayDayBuilder: (ctx, date, _) => Container(
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            right: 1,
                            left: 1,
                            child: Container(
                              width: 10,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                selectedDayBuilder: (context, date, events) => Container(
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            right: 1,
                            left: 1,
                            child: Container(
                              width: 10,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.redAccent[400],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                dayBuilder: (ctx, date, events) => Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                dowWeekdayBuilder: (ctx, dayString) => Center(
                      child: Text(
                        dayString,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                dowWeekendBuilder: (ctx, dayString) => Center(
                      child: Text(
                        dayString,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
          ),
        ),
        FutureBuilder<FredericUser>(
          future: user.loadData(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              FredericWorkout workout =
                  FredericWorkout('kKOnczVnBbBHvmx96cjG', true, true);
              Stream<FredericWorkout> stream = workout.asStream();
              var broadcast = stream.asBroadcastStream();
              return StreamBuilder<FredericWorkout>(
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    switch (_selectedDate) {
                      case 1:
                        _selectedEvents = snapshot.data.activities.monday;
                        break;
                      case 2:
                        _selectedEvents = snapshot.data.activities.tuesday;
                        break;
                      case 3:
                        _selectedEvents = snapshot.data.activities.wednesday;
                        break;
                      case 4:
                        _selectedEvents = snapshot.data.activities.thursday;
                        break;
                      case 5:
                        _selectedEvents = snapshot.data.activities.friday;
                        break;
                      case 6:
                        _selectedEvents = snapshot.data.activities.saturday;
                        break;
                      case 7:
                        _selectedEvents = snapshot.data.activities.sunday;
                        break;
                      default:
                    }
                    return _selectedEvents.length <= 0
                        ? Text('Feiertag!')
                        : Container(
                            height: 600,
                            child: ListView.builder(
                                itemCount: _selectedEvents.length,
                                itemBuilder: (ctx, index) {
                                  return ActivityInWorkout(
                                      snapshot.data.activities.tuesday[index]);
                                }),
                          );
                  } else {
                    return Text('loading data');
                  }
                },
                stream: broadcast,
              );
            } else {
              return Center(
                child: Text('Loading Workout'),
              );
            }
          },
        ),
      ],
    );
  }
}