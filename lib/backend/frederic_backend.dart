import 'dart:async';

import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend {
  FredericBackend() {
    _userManager =
        FredericUserManager(onLoadData: loadData, logTransition: true);
  }

  static FredericBackend get instance => getIt<FredericBackend>();

  late final FredericUserManager _userManager;
  FredericUserManager get userManager => _userManager;

  FredericActivityManager? _activityManager;
  FredericActivityManager? get activityManager => _activityManager;

  FredericWorkoutManager? _workoutManager;
  FredericWorkoutManager? get workoutManager => _workoutManager;

  FredericGoalManager? _goalManager;
  FredericGoalManager? get goalManager => _goalManager;

  Future<void> loadData() async {
    //TODO: wait until data loaded to complete

    _activityManager = FredericActivityManager();
    _activityManager?.loadData();
    await _activityManager?.hasData();
    _workoutManager = FredericWorkoutManager();
    _workoutManager?.loadData();
    _goalManager = FredericGoalManager();
    _goalManager?.loadData();
    return;
  }

  void dispose() {
    _activityManager?.dispose();
    _workoutManager?.dispose();
    _goalManager?.dispose();
  }
}
