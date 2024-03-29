import 'dart:collection';

import 'frederic_goal.dart';

class FredericGoalListData {
  FredericGoalListData(this.changed, this.goals);

  List<String> changed;
  HashMap<String, FredericGoal> goals;

  List<FredericGoal> getGoals() {
    return goals.values.where((element) => !element.isCompleted).toList();
  }

  List<FredericGoal> getAchievements() {
    return goals.values
        .where((element) => element.isCompleted && !element.isDeleted)
        .toList();
  }

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => changed.hashCode;
}
