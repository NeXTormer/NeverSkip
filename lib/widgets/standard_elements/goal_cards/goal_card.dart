import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/achievement_goal_card.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/normal_goal_card.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
import 'package:frederic/widgets/standard_elements/unit_slider.dart';

enum GoalCardType { Normal, Achievement }

class GoalCard extends StatelessWidget {
  const GoalCard(this.goal,
      {this.type = GoalCardType.Normal,
      this.sets,
      this.activity,
      this.startDate,
      this.endDate,
      this.titleController,
      this.startStateController,
      this.currentStateController,
      this.endStateController,
      this.unitSliderController,
      this.interactable = true,
      this.index = 0});

  final FredericGoal goal;

  final GoalCardType type;

  final FredericSetListData? sets;
  final FredericActivity? activity;

  final DateTime? startDate;
  final DateTime? endDate;

  final TextEditingController? titleController;

  final NumberSliderController? startStateController;
  final NumberSliderController? currentStateController;
  final NumberSliderController? endStateController;

  final UnitSliderController? unitSliderController;

  final bool interactable;

  final int index;

  @override
  Widget build(BuildContext context) {
    if (type == GoalCardType.Achievement) {
      return AchievementGoalCard(goal, index: index);
    }
    if (type == GoalCardType.Normal) {
      return NormalGoalCard(
        goal,
        sets: sets,
        activity: activity,
        startStateController: startStateController,
        currentStateController: currentStateController,
        endStateController: endStateController,
        titleController: titleController,
        unitSliderController: unitSliderController,
        interactable: interactable,
      );
    }

    return Container(
        color: Colors.redAccent,
        height: 40,
        width: 200,
        child: Center(child: Text("error")));
  }
}