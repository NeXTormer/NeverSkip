import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FredericUserManager, FredericUser>(
          builder: (context, user) {
        return BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
            builder: (context, workoutListData) {
          return CustomScrollView(
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
                          'Upcoming exercises',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('get to work!',
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
              if (false)
                SliverToBoxAdapter(child: BlocBuilder<FredericActivityManager,
                    FredericActivityListData>(
                  builder: (context, data) {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ActivityCard(data.activities.values.last),
                          SizedBox(height: 16),
                          ActivityCard(data.activities.values.last,
                              addButton: true, onClick: () => print('add')),
                          SizedBox(height: 16),
                          ActivityCard(data.activities.values.last,
                              type: ActivityCardType.Calendar),
                          SizedBox(height: 16),
                          ActivityCard(data.activities.values.last,
                              type: ActivityCardType.Small),
                          SizedBox(height: 16),
                          ActivityCard(
                            data.activities.values.last,
                            type: ActivityCardType.WorkoutEditor,
                            onClick: () => print('delete'),
                          ),
                        ],
                      ),
                    );
                  },
                )),

              //   (context, index) {
              //     return ActivityCard(FredericBackend
              //         .instance.activityManager['ATo1D6xT5G5oi9W6s1q9']!);
              //     return CalendarDay(index, user,
              //         FredericBackend.instance.workoutManager!);
              //   },
              // ))
            ],
          );
        });
      }),
    );
  }
}
