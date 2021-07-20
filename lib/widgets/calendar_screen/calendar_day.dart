import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarDay extends StatelessWidget {
  CalendarDay(this.index, this.user, this.workoutListData, this.setListData) {
    today = index == 0;
  }

  final FredericUser user;
  final FredericWorkoutListData workoutListData;
  final FredericSetListData? setListData;

  late final bool today;

  final int index;

  @override
  Widget build(BuildContext context) {
    DateTime day = DateTime.now().add(Duration(days: index));
    List<FredericActivity> activities = <FredericActivity>[];
    for (String workout in user.activeWorkouts) {
      if (workoutListData.workouts[workout] != null)
        activities
            .addAll(workoutListData.workouts[workout]!.activities.getDay(day));
    }
    List<bool> finished =
        today ? List.filled(activities.length, false) : <bool>[];
    bool dayFinished = true;
    if (today) {
      if (setListData != null) {
        for (int i = 0; i < activities.length; i++) {
          FredericSetList setList = setListData![activities[i].activityID];
          bool activityFinished = setList.wasActiveToday();
          finished[i] = activityFinished;
          if (activityFinished == false) {
            dayFinished = false;
          }
        }
      }
    }

    return Container(
        padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            if (day.day == 1 || index == 0) _CalendarMonthCard(day),
            if (day.day == 1 || index == 0) SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CalendarDayCard(day, dayFinished && today),
                Expanded(
                  child: Column(
                    children: List.generate(
                        activities.length,
                        (i) => _CalendarActivityCard(activities[i],
                            indicator: index == 0,
                            completed: finished.isNotEmpty && finished[i])),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

class _CalendarMonthCard extends StatelessWidget {
  _CalendarMonthCard(this.day);

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${getMonthName(day)}',
              style: GoogleFonts.montserrat(
                  color: const Color(0xFF272727),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.6,
                  fontSize: 15)),
          SizedBox(width: 8),
          Text('${day.year}',
              style: GoogleFonts.montserrat(
                  color: const Color(0xFF272727),
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.6,
                  fontSize: 13)),
        ],
      ),
    );
  }

  String getMonthName(DateTime day) {
    switch (day.month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
    }
    return '';
  }
}

class _CalendarActivityCard extends StatelessWidget {
  _CalendarActivityCard(this.activity,
      {this.completed = false, this.indicator = false});

  final FredericActivity activity;
  final bool indicator;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16, left: 8),
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _CalendarTimeLine(
            isActive: indicator,
            activeColor: completed ? kGreenColor : kMainColor,
          ),
          SizedBox(width: 8),
          Expanded(
              child: ActivityCard(activity,
                  type: ActivityCardType.Calendar,
                  state: completed
                      ? ActivityCardState.Green
                      : ActivityCardState.Normal))
        ],
      ),
    );
  }
}

class _CalendarTimeLine extends StatelessWidget {
  const _CalendarTimeLine(
      {this.isActive = false, this.activeColor = const Color(0xFF3E4FD8)});

  final bool isActive;

  final Color activeColor;
  final Color disabledColor = const Color(0x66A5A5A5);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: isActive
                ? [
                    circle(activeColor, 8),
                    circle(activeColor.withOpacity(0.1), 16)
                  ]
                : [
                    circle(disabledColor, 10),
                    circle(Colors.white, 6),
                    circle(Colors.transparent, 16)
                  ],
          ),
          SizedBox(height: 4),
          Expanded(
            child: Container(
              width: 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isActive
                          ? [activeColor, activeColor.withAlpha(0)]
                          : [disabledColor, disabledColor.withAlpha(0)]),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
            ),
          ),
        ],
      ),
    );
  }

  Widget circle(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }
}

class _CalendarDayCard extends StatelessWidget {
  _CalendarDayCard(this.day, [this.completed = false]);
  final DateTime day;
  final completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: completed ? kGreenColorLight : kMainColorLight),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: GoogleFonts.montserrat(
                  color: completed ? kGreenColor : kMainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            Text('${getWeekdayName(day.weekday)}',
                style: GoogleFonts.montserrat(
                    color: completed ? kGreenColor : kMainColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w300))
          ]),
    );
  }

  String getWeekdayName(int index) {
    switch (index) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return 'Err';
  }
}
