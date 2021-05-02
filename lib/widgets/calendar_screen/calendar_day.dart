import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/activity_card.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarDay extends StatelessWidget {
  CalendarDay(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    DateTime day = DateTime.now().add(Duration(days: index));

    return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CalendarDayCard(day),
            Expanded(
              child: Column(
                children: [
                  _CalendarActivityCard(),
                  _CalendarActivityCard(),
                  _CalendarActivityCard(),
                  _CalendarActivityCard(),
                ],
              ),
            )
          ],
        ));
  }
}

class _CalendarActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16, left: 8),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _CalendarTimeLine(false),
          SizedBox(width: 8),
          Expanded(child: ActivityCard())
        ],
      ),
    );
  }
}

class _CalendarTimeLine extends StatelessWidget {
  const _CalendarTimeLine([this.isActive = false]);

  final bool isActive;

  final Color activeColor = const Color(0xFF3E4FD8);
  final Color disabledColor = const Color(0x66A5A5A5);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: isActive
                ? [circle(kMainColor, 8), circle(kMainColorLight, 16)]
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
  _CalendarDayCard(this.day);
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kMainColorLight),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: GoogleFonts.montserrat(
                  color: kMainColor, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Text('${getWeekdayName(day.weekday)}',
                style: GoogleFonts.montserrat(
                    color: kMainColor,
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
  }
}
