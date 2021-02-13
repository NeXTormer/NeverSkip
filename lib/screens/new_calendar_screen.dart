import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliver_calendar/sliver_calendar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'dart:math';

class NewCalendarScreen extends StatefulWidget {
  @override
  _NewCalendarScreenState createState() => _NewCalendarScreenState();
}

class _NewCalendarScreenState extends State<NewCalendarScreen> {
  List<CalendarEvent> _events = [];
  Random _random = new Random();
  String _timezone = 'Unknown';
  tz.Location _location;
  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  Widget _buildItem(BuildContext context, CalendarEvent event) {
    return Card(
      child: ListTile(
        title: Text('Test ${event.index}'),
        subtitle: Text('Testing some events'),
        leading: Icon(Icons.person),
      ),
    );
  }

  List<CalendarEvent> _getEvents(DateTime start, DateTime end) {
    if (_events.length == 0) {
      tz.TZDateTime nowTime =
          tz.TZDateTime.now(_location).subtract(Duration(days: 5));
      for (int i = 0; i < 2; i++) {
        tz.TZDateTime start =
            nowTime.add(Duration(days: i + _random.nextInt(10)));
        _events.add(CalendarEvent(
            index: i,
            instant: start,
            instantEnd: start.add(Duration(minutes: 30))));
      }
    }
    return _events;
  }

  Future<void> initPlatformState() async {
    String timezone;

    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      timezone = 'Failed to get the timezone';
    }
    if (!mounted) return;
    setState(() {
      _timezone = timezone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          Text(_timezone),
          FutureBuilder(
            future: FlutterNativeTimezone.getLocalTimezone(),
            builder: (context, snapshot) {
              tz.initializeTimeZones();
              if (snapshot.hasData) {
                _location = tz.getLocation(snapshot.data);
                tz.TZDateTime nowTime = tz.TZDateTime.now(_location);
                return Expanded(
                  child: CalendarWidget(
                    initialDate: nowTime,
                    beginningRangeDate: nowTime.subtract(Duration(days: 31)),
                    endingRangeDate: nowTime.add(Duration(days: 31)),
                    location: _location,
                    buildItem: _buildItem,
                    getEvents: _getEvents,
                    weekBeginsWithDay: 1,
                    bannerHeader: NetworkImage(
                        'https://www.fitforfun.de/files/images/201712/1/istock-628092286,276242_m_n.jpg'),
                  ),
                );
              }
              return Center(child: Text('No Data'));
            },
          ),
        ],
      ),
    );
  }
}
