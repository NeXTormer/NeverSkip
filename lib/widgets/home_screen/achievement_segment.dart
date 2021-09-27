import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card.dart';

class AchievementSegment extends StatelessWidget {
  const AchievementSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child:
        BlocBuilder<FredericGoalManager, FredericGoalListData>(
            builder: (context, goalListData) {
      List<FredericGoal> goals = goalListData.getAchievements();
      return BlocBuilder<FredericSetManager, FredericSetListData>(
          builder: (context, setData) {
        return BlocBuilder<FredericActivityManager, FredericActivityListData>(
            builder: (context, activityListData) {
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 22, bottom: 8),
                  child: FredericHeading(
                    'Achievements',
                    onPressed: () {},
                  )),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Container(
                          child: GoalCard(
                            goals[index],
                            type: GoalCardType.Achievement,
                            sets: setData,
                            activity: activityListData
                                .activities[goals[index].activityID],
                            index: index + 1,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        });
      });
    }));
  }
}
