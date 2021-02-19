import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/providers/activity.dart';
import 'package:intl/intl.dart';

import 'activity_calendar_card_screen.dart';

class BuildCalendarView extends StatefulWidget {
  BuildCalendarView({
    @required this.startDate,
    @required this.events,
    @required this.endDate,
    @required this.monthImgHeaderUrl,
    this.workoutToLoad,
    this.sideColumnWidth,
    this.dateTitleTextStyle,
    this.weekTextStyle,
  });
  final FredericWorkout workoutToLoad;
  final DateTime startDate;
  final List<ActivityItem> events;
  final List<String> monthImgHeaderUrl;
  final DateTime endDate;
  final double sideColumnWidth;
  final TextStyle dateTitleTextStyle;
  final TextStyle weekTextStyle;

  @override
  _BuildCalendarViewState createState() => _BuildCalendarViewState();
}

class _BuildCalendarViewState extends State<BuildCalendarView> {
  List<CalendarMonth> _months = [];
  int _displayWeeksIndex = 0;

  @override
  Widget build(BuildContext context) {
    int _monthsToGenrate = widget.endDate.month;

    return StreamBuilder<FredericWorkout>(
        stream: widget.workoutToLoad.asBroadcastStream(),
        builder: (context, snapshot) {
          List<FredericActivityWithDate> activitiesWithDate = [];
          if (snapshot.hasData) {
            activitiesWithDate = _convertDayEntryToDateOfFredericActivity(
                snapshot.data.activities.activities, DateTime(2021, 1, 1));

            return ListView.builder(
              itemCount: _monthsToGenrate,
              itemBuilder: (ctx, index) {
                return Column(
                  children: _buildMonthCalendarItem(
                    _dummy,
                    _months[index],
                    activitiesWithDate,
                  ),
                );
              },
            );
          }
          return Text('loading');
        });
  }

  List<ActivityItem> _dummy = [
    ActivityItem(
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '1.01.2021',
    ),
    ActivityItem(
      activityID: 'a2',
      owner: 'a1',
      name: 'Diamond',
      description: 'Diamond Push Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
      date: '1.01.2021',
    ),
    ActivityItem(
      activityID: 'a3',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '1.01.2021',
    ),
    ActivityItem(
      activityID: 'a4',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '28.02.2021',
    ),
  ];

  @override
  void initState() {
    for (int month = 1; month <= widget.endDate.month; month++) {
      _months.add(
        CalendarMonth(
          _getMonthTitleAsString(month),
          2021,
          month,
          DateUtil().daysInMonth(month, 2021),
          widget.monthImgHeaderUrl[month - 1],
        ),
      );
    }
    super.initState();
  }

  Widget _buildMonthHeader(String imageUrl, String month) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          top: 10,
          left: 50.0,
          child: Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                //border: Border.all(width: 0.5),
                color: Colors.white),
            child: Text(
              month,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthTitleAsString(int month) {
    switch (month) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'Feburary';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'Oktober';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
      default:
        return '';
    }
  }

  List<FredericActivityWithDate> _splitEventIntoWeekDate(
      List<FredericActivityWithDate> events, int month, int weekday) {
    return events
        .where((element) =>
            element.date.day <= ((weekday + 1) * 7) &&
            element.date.day > ((weekday + 1) * 7 - 7) &&
            element.date.month == month)
        .toList();
  }

  List<FredericActivityWithDate> _convertDayEntryToDateOfFredericActivity(
      List<List<FredericActivity>> activities, DateTime startDate) {
    List<FredericActivityWithDate> activitiesWithDate = [];
    for (int week = 0; week < activities.length; week++) {
      for (int day = 0; day < activities[week].length; day++) {
        if (!activities[week][day].isNull) {
          FredericActivityWithDate withDate = FredericActivityWithDate(
              activities[week][day],
              startDate.add(Duration(days: ((week + 1) * (day + 1)))));
          activitiesWithDate.add(withDate);
        }
      }
    }
    return activitiesWithDate;
  }

  List<Widget> _buildMonthCalendarItem(List<ActivityItem> events,
      CalendarMonth month, List<FredericActivityWithDate> activities) {
    int daysInMonth = month.days;
    int generateWeeksLoop = daysInMonth < 30 ? 4 : 5;

    return List.generate(
      generateWeeksLoop,
      (index) {
        _displayWeeksIndex++;
        List<FredericActivityWithDate> eventsOnSpecificDate;
        List<Widget> output = [];
        List<FredericActivityWithDate> monthEvents =
            _splitEventIntoWeekDate(activities, month.month, index);

        if (monthEvents.length > 0) {
          Set<String> dates = {};
          for (int i = 0; i < monthEvents.length; i++) {
            dates.add(DateFormat('dd.MM.yyyy').format(monthEvents[i].date));
          }

          for (int day = 0; day < dates.length; day++) {
            eventsOnSpecificDate = monthEvents
                .where((element) =>
                    DateFormat('dd.MM.yyyy').format(element.date) ==
                    dates.toList()[day])
                .toList();
            var date = eventsOnSpecificDate[0].date;
            var dateTime = DateTime(date.year, date.month, date.day);
            output.add(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: widget.sideColumnWidth,
                    child: Column(
                      children: [
                        Text(
                          DateFormat('EEEE').format(dateTime).substring(0, 3),
                          style: widget.dateTitleTextStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ...eventsOnSpecificDate.map(
                          (e) => ActivityCalendarCard(
                              e.activity, Key('${e.activity.activityID}')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0)
              _buildMonthHeader(
                month.imageUrl,
                month.name,
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildWeekText(daysInMonth, index),
            ),
            ...output,
          ],
        );
      },
    );
  }

  Widget _buildWeekText(int daysInMonth, int month) {
    return Row(
      children: [
        SizedBox(width: widget.sideColumnWidth),
        _displayWeeksIndex * 7 >= daysInMonth
            ? Text(
                'January ${(month * 7) + 1} - $daysInMonth',
                style: widget.weekTextStyle,
              )
            : Text(
                'January ${(month * 7) + 1} - ${_displayWeeksIndex * 7}',
                style: widget.weekTextStyle,
              ),
      ],
    );
  }
}

class CalendarMonth {
  CalendarMonth(this.name, this.year, this.month, this.days, this.imageUrl);

  final String name;
  final int year;
  final int month;
  final int days;
  final String imageUrl;
}

class FredericActivityWithDate {
  FredericActivityWithDate(this.activity, this.date);

  final FredericActivity activity;
  final DateTime date;
}
