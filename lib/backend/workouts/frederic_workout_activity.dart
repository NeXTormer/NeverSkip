import 'package:frederic/backend/activities/frederic_activity.dart';

class FredericWorkoutActivity implements Comparable {
  FredericWorkoutActivity(
      {required this.activity,
      required this.weekday,
      this.order = 0,
      int? sets,
      int? reps})
      : _sets = sets,
        _reps = reps;

  FredericWorkoutActivity.fromMap(this.activity, Map<String, dynamic> data)
      : weekday = data['weekday'],
        order = data['order'] ?? 0,
        _sets = data['sets'],
        _reps = data['reps'];

  final FredericActivity activity;
  final int weekday;
  int order;
  int? _sets;
  int? _reps;

  int get sets => _sets ?? activity.recommendedSets;
  int get reps => _reps ?? activity.recommendedReps;

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