import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend {
  FredericBackend() {
    _userManager =
        FredericUserManager(onLoadData: loadData, logTransition: false);
    _activityManager = FredericActivityManager();
    _setManager = FredericSetManager();
    _workoutManager = FredericWorkoutManager();
    _goalManager = FredericGoalManager();
  }

  static FredericBackend get instance => getIt<FredericBackend>();

  late final FredericUserManager _userManager;
  FredericUserManager get userManager => _userManager;

  late final FredericSetManager _setManager;
  FredericSetManager get setManager => _setManager;

  late final FredericActivityManager _activityManager;
  FredericActivityManager get activityManager => _activityManager;

  late final FredericWorkoutManager _workoutManager;
  FredericWorkoutManager get workoutManager => _workoutManager;

  late final FredericGoalManager _goalManager;
  FredericGoalManager get goalManager => _goalManager;

  void loadData() {
    //TODO: wait until data loaded to complete

    _activityManager.reload();
    _workoutManager.reload();
    _goalManager.loadData();
  }

  void dispose() {
    _goalManager.dispose();
  }
}
