import 'dart:async';

import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/analytics/frederic_analytics_service.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/storage/frederic_storage_manager.dart';
import 'package:frederic/backend/util/event_bus/frederic_event_bus.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/backend/workouts/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend {
  FredericBackend() {
    _eventBus = FredericEventBus();

    _userManager = FredericUserManager(
        onLoadData: loadData, logTransition: false, backend: this);
    _activityManager = FredericActivityManager();
    _setManager = FredericSetManager();
    _workoutManager = FredericWorkoutManager();
    _goalManager = FredericGoalManager();
    _storageManager = FredericStorageManager(this);
    _analyticsService = FredericAnalyticsService();

    _registerEventProcessors();
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

  late final FredericEventBus _eventBus;
  FredericEventBus get eventBus => _eventBus;

  late final FredericStorageManager _storageManager;
  FredericStorageManager get storageManager => _storageManager;

  late final FredericAnalyticsService _analyticsService;
  FredericAnalyticsService get analyticsService => _analyticsService;

  bool _hasDataLoaded = false;
  List<Completer<void>> _dataLoadedCompleters = <Completer<void>>[];

  Future<void> waitUntilDataIsLoaded() async {
    if (_hasDataLoaded) return;
    Completer<void> completer = Completer<void>();
    _dataLoadedCompleters.add(completer);
    return completer.future;
  }

  void loadData() async {
    var profiler = FredericProfiler.track('[Backend] load all data');
    await _activityManager.reload();
    await _workoutManager.reload();
    await _goalManager.reload();
    _hasDataLoaded = true;
    for (Completer completer in _dataLoadedCompleters) {
      completer.complete();
    }
    profiler.stop();
  }

  void _registerEventProcessors() {
    eventBus.addEventProcessor(_analyticsService);
  }

  void dispose() {}
}
