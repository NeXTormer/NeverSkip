import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/screens/edit_goal_data_screen.dart';
import 'package:frederic/widgets/home_screen/goal_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GoalSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 22, bottom: 8),
            child: FredericHeading(
              'MyGoals',
              onPressed: () => handleClick(context),
              icon: Icons.add,
            ),
          ),
          // TODO Allow permission on database
          BlocBuilder<FredericGoalManager, FredericGoalListData>(
              builder: (context, goalListData) {
            List<FredericGoal> goals = goalListData.getGoals();
            return Container(
              height: 70,
              child: ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: goals.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16 : 12,
                        right: index == ([1].length - 1) ? 16 : 0),
                    child: GoalCard(goals[index]),
                  );
                },
              ),
            );
          })
        ],
      ),
    );
  }

  void handleClick(BuildContext context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (c) => Scaffold(
            body: EditGoalDataScreen(
                FredericGoal.empty(FredericBackend.instance.goalManager))));
  }
}
