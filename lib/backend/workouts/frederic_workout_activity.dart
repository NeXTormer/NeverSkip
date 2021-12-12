import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/backend.dart';

class FredericWorkoutActivity implements Comparable {
  FredericWorkoutActivity(
      {required this.activity,
      required int weekday,
      this.order = 0,
      int? sets,
      int? reps})
      : _sets = sets,
        _weekday = weekday,
        _reps = reps;

  FredericWorkoutActivity.fromMap(this.activity, Map<String, dynamic> data)
      : _weekday = data['weekday'],
        order = data['order'] ?? 0,
        _sets = data['sets'],
        _reps = data['reps'];

  final FredericActivity activity;
  int _weekday;
  int order;
  int? _sets;
  int? _reps;

  set sets(int value) {
    _sets = value;
  }

  set reps(int value) {
    _reps = value;
  }

  void changeWeekday(int value) => _weekday = value;

  int get sets => _sets ?? activity.recommendedSets;
  int get reps => _reps ?? activity.recommendedReps;
  int get weekday => _weekday;

  Map<String, dynamic> toMap() {
    return {
      'activityid': activity.activityID,
      'weekday': weekday,
      'order': order,
      'sets': _sets,
      'reps': _reps
    };
  }

  @override
  int compareTo(other) {
    if (other is FredericWorkoutActivity) {
      return order - other.order;
    }
    return 1;
  }
}
