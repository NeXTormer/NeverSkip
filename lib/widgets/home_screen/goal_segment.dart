import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/screens/edit_goal_data_screen.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                    left: 16, right: 16, top: 22, bottom: 8),
                child: FredericHeading(
                  'My Goals',
                  onPressed: () => handleClick(context, setData),
                  icon: Icons.add,
                ),
              ),
              Container(
                height: 70,
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: user.goalsCount,
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
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 16 : 12,
                            right: index == ([1].length - 1) ? 16 : 0),
                        child: GoalCard(null),
                      );
                    }
                  },
                ),
              ),
            ]);
          });
        });
      }));
    });
  }

  void handleClick(BuildContext context, FredericSetListData setData) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
      context: context,
      builder: (c) => Scaffold(
          body: EditGoalDataScreen(
        FredericGoal.empty(FredericBackend.instance.goalManager),
        sets: setData,
      )),
    );
  }
}
