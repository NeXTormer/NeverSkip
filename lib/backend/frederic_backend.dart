import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
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
  }

  static FredericBackend get instance => getIt<FredericBackend>();

  late final FredericUserManager _userManager;
  FredericUserManager get userManager => _userManager;

  final FredericSetManager _setManager = FredericSetManager();
  FredericSetManager get setManager => _setManager;

  late FredericActivityManager _activityManager;
  FredericActivityManager get activityManager => _activityManager;

  FredericWorkoutManager? _workoutManager;
  FredericWorkoutManager? get workoutManager => _workoutManager;

  FredericGoalManager? _goalManager;
  FredericGoalManager? get goalManager => _goalManager;

  void loadData() {
    //TODO: wait until data loaded to complete

    _activityManager.reload();
    FredericSetList setList = setManager['ATo1D6xT5G5oi9W6s1q9'];
    print(setList.activityID);
    Future.delayed(Duration(seconds: 2))
        .then((value) => setList.addSet(FredericSet(4, 40, DateTime.now())));
    _workoutManager = FredericWorkoutManager();
    _workoutManager?.loadData();
    _goalManager = FredericGoalManager();
    _goalManager?.loadData();
  }

  void dispose() {
    _workoutManager?.dispose();
    _goalManager?.dispose();
  }
}
