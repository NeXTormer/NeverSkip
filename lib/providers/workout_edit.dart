import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/providers/activity.dart';

class WorkoutItem {
  FredericActivity activity;
  int day;
}

class WorkoutEdit with ChangeNotifier {
  Map<int, List<ActivityItem>> _test = {
    1: [
      ActivityItem(
        activityID: 'a10',
        owner: null,
        name: 'Pull Up',
        description: 'Pull Up',
        image:
            'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
      ),
    ],
  };

  Map<int, List<ActivityItem>> get allWorkoutActivities {
    return _test;
  }

  List<ActivityItem> getListPerDay(int day) {
    return _test[day];
  }

  void addActivityToDay(int day, ActivityItem activityItem) {
    try {
      _test[day].add(activityItem);
    } catch (error) {
      _test.addAll({
        day: [activityItem]
      });
    }
    notifyListeners();
  }
}
