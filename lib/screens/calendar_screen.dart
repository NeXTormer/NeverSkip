import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/calendar_screen/calendar_day.dart';
import 'package:frederic/widgets/sliver_divider.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    ExtraIcons.calendar,
                    color: kMainColor,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Today\'s exercises',
                      style: true
                          ? GoogleFonts.montserrat(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 17)
                          : TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 18,
                    decoration: BoxDecoration(
                        color: const Color(0xFFCDCDCD),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('May 2021',
                        style: GoogleFonts.montserrat(
                            color: const Color(0xF2A5A5A5),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0.6)),
                  ),
                ],
              ),
            ),
          ),
          SliverDivider(),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) {
              return CalendarDay(index);
            },
          ))
        ],
      ),
    );
  }
}
