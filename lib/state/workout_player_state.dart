import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';

class WorkoutPlayerState extends ChangeNotifier {
  Timer? timer;

  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;
  set elapsedSeconds(int value) {
    _elapsedSeconds = value;
    notifyListeners();
  }

  int _totalSets = 0;
  int get totalSets => _totalSets;

  int _completedSets = 0;
  int get completedSets => _completedSets;

  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;
  set showProgressBar(bool value) {
    _showProgressBar = value;
    notifyListeners();
  }

  Map<String, SetTracker> sets = <String, SetTracker>{};

  void setupProgressBar(List<FredericWorkoutActivity> activities) {
    sets.clear();
    for (var activity in activities) {
      if (sets.containsKey(activity.activity.id)) {
        sets[activity.activity.id]?.totalSets += activity.sets;
      } else {
        sets[activity.activity.id] = SetTracker()..totalSets = activity.sets;
      }
      _totalSets += activity.sets;
    }
  }

  void addProgress(FredericActivity activity, FredericSet set) {
    SetTracker? tracker = sets[activity.id];
    if (tracker != null) {
      if (tracker.finishedSets < tracker.totalSets) {
        tracker.finishedSets++;
        _completedSets++;
        notifyListeners();
      } else {
        tracker.finishedSets++;
      }
    }
  }

  void removeProgress(FredericActivity activity, FredericSet set) {
    SetTracker? tracker = sets[activity.id];
    if (tracker != null) {
      if (tracker.finishedSets > 0) {
        tracker.finishedSets--;
        if (tracker.finishedSets < tracker.totalSets) {
          _completedSets--;
          notifyListeners();
        }
      }
    }
  }

  double getProgress() {
    if (_totalSets == 0) return 0;
    return _completedSets / _totalSets;
  }

  void resumeTimer() {
    if (timer == null)
      timer = Timer.periodic(Duration(seconds: 1), _timerHandler);
  }

  void pauseTimer() {
    timer?.cancel();
  }

  void _timerHandler(timer) {
    elapsedSeconds++;
  }

  String getCurrentTime() {
    return '${(_elapsedSeconds ~/ 60)}:${_elapsedSeconds % 60}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class SetTracker {
  int totalSets = 0;
  int finishedSets = 0;
}
