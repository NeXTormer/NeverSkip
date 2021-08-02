import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/calendar_screen/calendar_day.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<FredericUserManager, FredericUser>(
            builder: (context, user) {
          return BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
              builder: (context, workoutListData) {
            return BlocBuilder<FredericSetManager, FredericSetListData>(
                builder: (context, setListData) {
              return CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16, left: 16, top: 16, bottom: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Let\'s get to work',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: const Color(0xFF272727),
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.6,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Upcoming exercises',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: const Color(0xFF272727),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              ExtraIcons.bell_1,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
                  SliverDivider(),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return CalendarDay(index, user, workoutListData,
                        index == 0 ? setListData : null);
                  }))
                ],
              );
            });
          });
        }),
      ),
    );
  }
}
