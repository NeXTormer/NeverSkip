import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';

class AchievementTimeline extends StatefulWidget {
  const AchievementTimeline(this.goal,
      {this.length = 100,
      this.height = 5,
      this.delayInMillisecond = 0,
      Key? key})
      : super(key: key);
  final FredericGoal goal;
  final double length;
  final double height;
  final int delayInMillisecond;

  @override
  _AchievementTimelineState createState() => _AchievementTimelineState();
}

class _AchievementTimelineState extends State<AchievementTimeline>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  bool _visibleDates = false;
  bool _visibleWeek = false;

  DateTime? _startDate;
  DateTime? _endDate;

  String _startDayString = '';
  String _endDayString = '';
  String _startMonthString = '';
  String _endMonthString = '';
  int _days = 0;

  static int delayDateInMilliseconds = 500;
  static int delayDaysInMilliseconds = 500;

  @override
  void initState() {
    _startDate = widget.goal.startDate;
    _endDate = widget.goal.endDate;

    _startDayString = dayToString(_startDate!.weekday);
    _endDayString = dayToString(_endDate!.weekday);
    _startMonthString = monthToString(_startDate!.month);
    _endMonthString = monthToString(_endDate!.month);
    _days = _endDate!.difference(_startDate!).inDays;

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn)
          ..addListener(() {
            if (_animation.isCompleted) _visibleWeek = true;
            setState(() {});
          });

    Future.delayed(Duration(milliseconds: (200 + widget.delayInMillisecond)),
        () {
      _controller.forward();
      _visibleDates = true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = _animation.value * widget.length;
    double containerWidthDate = _animation.value * (widget.length - 110);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_startMonthString),
            Text(_endMonthString),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: theme.mainColor,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            width: containerWidth,
            height: widget.height,
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            animatedDateOpacity('${_startDate!.day}\n$_startDayString',
                delayDateInMilliseconds),
            animatedDaysText(
                '$_days Days', containerWidthDate, delayDaysInMilliseconds),
            animatedDateOpacity(
                '${_endDate!.day}\n$_endDayString', delayDateInMilliseconds),
          ],
        ),
      ],
    );
  }

  Widget animatedDaysText(String text, double width, int delayInMilliseconds) {
    return Container(
      height: 20,
      width: width,
      child: AnimatedOpacity(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: delayInMilliseconds),
        opacity: _visibleWeek ? 1.0 : 0.0,
        child: Stack(
          children: [
            Center(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

  Widget animatedDateOpacity(String text, int delayInMilliseconds) {
    return AnimatedOpacity(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: delayInMilliseconds),
      opacity: _visibleDates ? 1.0 : 0.0,
      child: Container(
        width: 45,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String dayToString(int day) {
    String result = 'yala';
    switch (day) {
      case 1:
        result = 'Mon';
        break;
      case 2:
        result = 'Tue';
        break;
      case 3:
        result = 'Wed';
        break;
      case 4:
        result = 'Thu';
        break;
      case 5:
        result = 'Fri';
        break;
      case 6:
        result = 'Sat';
        break;
      case 7:
        result = 'Sun';
        break;
      default:
        break;
    }
    return result;
  }

  String monthToString(int month) {
    String result = '';
    switch (month) {
      case 1:
        result = 'January';
        break;
      case 2:
        result = 'February';
        break;
      case 3:
        result = 'March';
        break;
      case 4:
        result = 'April';
        break;
      case 5:
        result = 'May';
        break;
      case 6:
        result = 'June';
        break;
      case 7:
        result = 'July';
        break;
      case 8:
        result = 'August';
        break;
      case 9:
        result = 'September';
        break;
      case 10:
        result = 'October';
        break;
      case 11:
        result = 'November';
        break;
      case 12:
        result = 'December';
        break;
      default:
        break;
    }
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
