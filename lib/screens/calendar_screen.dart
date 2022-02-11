import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/calendar_screen/calendar_day.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
          builder: (context, user) {
        return BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
            builder: (context, workoutListData) {
          return BlocBuilder<FredericSetManager, FredericSetListData>(
              builder: (context, setListData) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                FredericSliverAppBar(
                  title: tr('calendar.title'),
                  subtitle: tr('calendar.subtitle'),
                  icon: StreakIcon(
                      user: user, onColorfulBackground: theme.isColorful),
                ),
                SliverPadding(padding: const EdgeInsets.only(bottom: 8)),
                //if (false)
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
    );
  }
}
