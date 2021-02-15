import 'package:flutter/material.dart';

enum GoalType {
  Weighted,
  Repetitions,
}

class GoalItem with ChangeNotifier {
  final String id;
  final String title;
  final double current;
  final double target;
  final int interval;
  final GoalType type;
  final String imageUrl;
  bool finished;

  GoalItem({
    @required this.id,
    @required this.title,
    @required this.current,
    @required this.target,
    @required this.interval,
    @required this.type,
    @required this.imageUrl,
    this.finished = false,
  });

  void finishGoal(String goalId) {
    finished = true;
    notifyListeners();
  }
}

class Goals with ChangeNotifier {
  List<GoalItem> _goals = [
    GoalItem(
      id: 'g1',
      title: 'Weight Loss',
      current: 82.5,
      target: 90.0,
      interval: 5,
      type: GoalType.Weighted,
      imageUrl:
          'https://images.contentstack.io/v3/assets/blt45c082eaf9747747/blt7fd9e5eb5024eac1/5de0bc063f764502b48c2586/Content1_CardiovsStrength.jpg?width=1232&auto=webp&format=progressive&quality=76',
    ),
    GoalItem(
      id: 'g2',
      title: 'Bench Press',
      current: 90,
      target: 100,
      type: GoalType.Weighted,
      interval: 3,
      imageUrl:
          'https://www.muscleandfitness.com/wp-content/uploads/2019/02/man-bench-press.jpg?quality=86&strip=all',
    ),
    GoalItem(
      id: 'g3',
      title: 'Pull Ups',
      current: 10,
      target: 15,
      interval: 2,
      type: GoalType.Repetitions,
      imageUrl:
          'https://www.holdstrong.de/magazin/wp-content/uploads/2019/06/butterfly-kipping-pull-up-750x500.jpg',
    ),
    GoalItem(
      id: 'g4',
      title: 'Biceps Curls',
      current: 10,
      target: 15,
      interval: 2,
      type: GoalType.Repetitions,
      finished: true,
      imageUrl:
          'https://www.holdstrong.de/magazin/wp-content/uploads/2019/06/butterfly-kipping-pull-up-750x500.jpg',
    ),
    GoalItem(
      id: 'g5',
      title: 'Squats',
      current: 10,
      target: 15,
      interval: 2,
      type: GoalType.Repetitions,
      finished: true,
      imageUrl:
          'https://www.holdstrong.de/magazin/wp-content/uploads/2019/06/butterfly-kipping-pull-up-750x500.jpg',
    ),
  ];
  // final String id;

  // Goals(this.id, this._goals);

  List<GoalItem> get goals {
    return [..._goals];
  }

  List<GoalItem> get finishedGoals {
    return _goals.where((goalItem) => goalItem.finished).toList();
  }

  List<GoalItem> get unfinishedGoals {
    return _goals.where((goalItem) => goalItem.finished == false).toList();
  }

  GoalItem findById(String id) {
    return _goals.firstWhere((goalItem) => goalItem.id == id);
  }

  void notifyGoals() {
    notifyListeners();
  }

  void addGoal(GoalItem goal) {
    goal = GoalItem(
        id: DateTime.now().toIso8601String(),
        title: goal.title,
        current: goal.current,
        target: goal.target,
        interval: goal.interval,
        type: goal.type,
        imageUrl: goal.imageUrl);
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(String id, GoalItem newGoalItem) {
    final goalIndex = _goals.indexWhere((goalItem) => goalItem.id == id);
    if (goalIndex >= 0) {
      _goals[goalIndex] = newGoalItem;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    final existingGoalIndex =
        _goals.indexWhere((goalItem) => goalItem.id == id);
    _goals.removeAt(existingGoalIndex);
    notifyListeners();
  }

  int get itemCount {
    return _goals.length;
  }
}
