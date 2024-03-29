import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/edit_goal_data_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card.dart';

class GoalSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) {
      return SliverToBoxAdapter(child:
          BlocBuilder<FredericGoalManager, FredericGoalListData>(
              builder: (context, goalListData) {
        List<FredericGoal>? goals = goalListData.getGoals();
        return BlocBuilder<FredericSetManager, FredericSetListData>(
            buildWhen: (current, next) {
          return next.changedActivities
              .any((element) => goals.contains(element));
        }, builder: (context, setData) {
          return BlocBuilder<FredericActivityManager, FredericActivityListData>(
              builder: (context, activityListData) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 6, bottom: 8),
                child: FredericHeading(
                  tr('home.my_goals'),
                  onPressed: () => handleNewGoal(context, setData),
                  icon: Icons.add,
                ),
              ),
              if (goals.length == 0)
                FredericCard(
                  height: 60,
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Center(
                      child: Text(
                    tr('home.no_active_goals'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.greyTextColor),
                  )),
                ),
              if (goals.length != 0)
                Container(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: goals.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      try {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 16 : 12,
                              right: index == ([1].length - 1) ? 16 : 0),
                          child: GoalCard(goals[index],
                              sets: setData,
                              activity: activityListData
                                  .activities[goals[index].activityID]),
                        );
                      } on RangeError catch (_) {
                        return Container(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 16 : 12,
                                right: index == ([1].length - 1) ? 16 : 0),
                            child: GoalCard(null),
                          ),
                        );
                      }
                    },
                  ),
                ),
              const SizedBox(height: 8)
            ]);
          });
        });
      }));
    });
  }

  void handleNewGoal(BuildContext context, FredericSetListData setData) {
    showFredericBottomSheet(
      context: context,
      builder: (c) => Scaffold(
          body: EditGoalDataScreen(
        FredericGoal.empty(),
        sets: setData,
      )),
    );
  }
}
