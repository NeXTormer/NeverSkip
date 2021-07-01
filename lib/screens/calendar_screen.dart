import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Container()
        // FredericUserBuilder(builder: (context, user) {
        //   return FredericWorkoutBuilder(
        //       activeWorkouts: user!.activeWorkouts, //TODO NULL SAFETY
        //       builder: (context, data) {
        //         List<FredericWorkout?> workouts = data;
        //         return CustomScrollView(
        //           physics: ClampingScrollPhysics(),
        //           slivers: [
        //             SliverAppBar(
        //               backgroundColor: Colors.white,
        //               title: Padding(
        //                 padding: EdgeInsets.only(top: 8),
        //                 child: Row(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     Icon(
        //                       ExtraIcons.calendar,
        //                       color: kMainColor,
        //                       size: 20,
        //                     ),
        //                     SizedBox(width: 12),
        //                     Padding(
        //                       padding: EdgeInsets.only(top: 2),
        //                       child: Text(
        //                         'Upcoming exercises',
        //                         style: true
        //                             ? GoogleFonts.montserrat(
        //                                 color: kTextColor,
        //                                 fontWeight: FontWeight.w500,
        //                                 fontSize: 17)
        //                             : TextStyle(
        //                                 color: kTextColor,
        //                                 fontWeight: FontWeight.w600,
        //                                 letterSpacing: 0.2),
        //                       ),
        //                     ),
        //                     if (false) SizedBox(width: 8),
        //                     if (false)
        //                       Container(
        //                         width: 1,
        //                         height: 18,
        //                         decoration: BoxDecoration(
        //                             color: const Color(0xFFCDCDCD),
        //                             borderRadius:
        //                                 BorderRadius.all(Radius.circular(100))),
        //                       ),
        //                     if (false) SizedBox(width: 8),
        //                     if (false)
        //                       Padding(
        //                         padding: const EdgeInsets.only(top: 2),
        //                         child: Text('get to work!',
        //                             style: GoogleFonts.montserrat(
        //                                 color: const Color(0xF2A5A5A5),
        //                                 fontWeight: FontWeight.w500,
        //                                 fontSize: 12,
        //                                 letterSpacing: 0.6)),
        //                       ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             SliverDivider(),
        //             SliverList(delegate: SliverChildBuilderDelegate(
        //               (context, index) {
        //                 return Container();
        //                 //return CalendarDay(index, user, workouts);
        //               },
        //             ))
        //           ],
        //         );
        //       });
        // }),
        );
  }
}
