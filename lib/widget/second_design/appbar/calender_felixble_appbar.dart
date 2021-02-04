import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderFlexibleAppbar extends StatefulWidget {
  @override
  _CalenderFlexibleAppbarState createState() => _CalenderFlexibleAppbarState();
}

class _CalenderFlexibleAppbarState extends State<CalenderFlexibleAppbar> {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TableCalendar(
        initialCalendarFormat: CalendarFormat.week,
        calendarController: _calendarController,
      ),
    );
  }
}
