import 'dart:collection';

import 'frederic_goal.dart';

class FredericGoalListData {
  FredericGoalListData(this.changed, this.goals);

  List<String> changed;
  HashMap<String, FredericGoal> goals;

  List<FredericGoal> getGoals() {
    return goals.values.toList();
  }

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => changed.hashCode;
}
