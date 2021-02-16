import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:frederic/providers/activity.dart';
import 'package:intl/intl.dart';

import 'file:///C:/Dev/Projects/frederic/lib/widgets/calendar_screen/activity_calendar_card_screen.dart';

class CalendarScreen extends StatefulWidget {
  static String routeName = '/newCalendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<String> _january = [];
  int _displayWeeksIndex = 0;

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
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '2.01.2021',
    ),
    ActivityItem(
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '15.01.2021',
    ),
  ];

  @override
  void initState() {
    for (DateTime indexDay = DateTime(2021, 1, 1);
        indexDay.month == 1;
        indexDay = indexDay.add(Duration(days: 1))) {
      _january.add(DateFormat('dd/MM/yyy').format(indexDay));
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
    }
  }

  List<Widget> _buildMonthCalendarItem(
      int month, List<ActivityItem> events, List<String> monthHeaderImageUrl) {
    String monthTitle = _getMonthTitleAsString(month);
    int daysInMonth = DateUtil().daysInMonth(month, 2021);
    return List.generate(
      5,
      (index) {
        _displayWeeksIndex++;
        List<ActivityItem> monthEvents = events
            .where((element) =>
                int.parse(element.date.split('.')[0]) <= ((index + 1) * 7) &&
                int.parse(element.date.split('.')[0]) > ((index + 1) * 7 - 7) &&
                int.parse(element.date.split('.')[1]) == month)
            .toList();
        List<Widget> output = [];

        if (monthEvents.length > 0) {
          Set<String> dates = {};
          for (int i = 0; i < monthEvents.length; i++) {
            dates.add(monthEvents[i].date);
          }
          List<ActivityItem> temp2;

          for (int day = 0; day < dates.length; day++) {
            temp2 = monthEvents
                .where((element) => element.date == dates.toList()[day])
                .toList();
            var date = temp2[0].date.split('.');
            var dateTime = DateTime(
                int.parse(date[2]), int.parse(date[1]), int.parse(date[0]));
            output.add(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Text(
                          DateFormat('EEEE').format(dateTime).substring(0, 3),
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            date[0],
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ...temp2.map(
                          (e) =>
                              ActivityCalendarCard(e, Key('${e.activityID}')),
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
                  'https://mobil.woman.at/_storage/asset/10566591/storage/womanat:content-large/file/140877089/Erwiesen:%20HIIT-Workout%20ist%20am%20effektivsten!.jpg',
                  'January'),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(width: 50),
                  _displayWeeksIndex * 7 >= daysInMonth
                      ? Text('January ${(index * 7) + 1} - ${daysInMonth}')
                      : Text(
                          'January ${(index * 7) + 1} - ${_displayWeeksIndex * 7}'),
                ],
              ),
            ),
            ...output,
            // if (index == 4)
            //   _buildMonthHeader(
            //     'https://www.emotion.de/sites/www.emotion.de/files/styles/article_lead/public/home-workout.jpg?itok=51YSMTu7',
            //     'February',
            //   ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leading: Icon(Icons.list),
          title: Text('Month'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.calendar_today),
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildMonthCalendarItem(1, _dummy, null),
            _buildMonthHeader(
                'https://www.emotion.de/sites/www.emotion.de/files/styles/article_lead/public/home-workout.jpg?itok=51YSMTu7',
                'February'),
          ],

          //_buildMonthCalendarItem(),
        ),
      ),
      //bottomNavigationBar: BottomNavDesign(1),
    );
  }
}
