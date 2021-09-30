import 'dart:async';

import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/analytics/frederic_analytics_service.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/concurrency/frederic_concurrency_message.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/storage/frederic_storage_manager.dart';
import 'package:frederic/backend/util/event_bus/frederic_base_message.dart';
import 'package:frederic/backend/util/event_bus/frederic_message_bus.dart';
import 'package:frederic/backend/util/event_bus/frederic_message_processor.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/backend/util/wait_for_x.dart';
import 'package:frederic/backend/workouts/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend extends FredericMessageProcessor {
  FredericBackend() {
    _eventBus = FredericMessageBus();

    _userManager = FredericUserManager(backend: this);
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

  late final FredericMessageBus _eventBus;
  FredericMessageBus get messageBus => _eventBus;

  late final FredericStorageManager _storageManager;
  FredericStorageManager get storageManager => _storageManager;

  late final FredericAnalyticsService _analyticsService;
  FredericAnalyticsService get analyticsService => _analyticsService;

  WaitForX _waitUntilCoreDataHasLoaded = WaitForX();
  Future<void> waitUntilCoreDataIsLoaded() =>
      _waitUntilCoreDataHasLoaded.waitForX();

  WaitForX _waitUntilUserHasAuthenticated = WaitForX();
  Future<void> waitUntilUserHasAuthenticated() =>
      _waitUntilUserHasAuthenticated.waitForX();

  @override
  bool acceptsMessage(FredericBaseMessage message) {
    return message is FredericConcurrencyMessage;
  }

  @override
  void processMessage(FredericBaseMessage message) {
    if (message is FredericConcurrencyMessage) {
      switch (message.type) {
        case FredericConcurrencyMessageType.CoreDataHasLoaded:
          break;
        case FredericConcurrencyMessageType.UserHasAuthenticated:
          _waitUntilUserHasAuthenticated.complete();
          loadData();
          break;
        default:
          break;
      }
    }
  }

  void loadData() async {
    var profiler = FredericProfiler.track('[Backend] load all data');
    _setManager.reload();
    await _activityManager.reload();
    await _workoutManager.reload();
    await _goalManager.reload();

    _waitUntilCoreDataHasLoaded.complete();
    profiler.stop();
  }

  void _registerEventProcessors() {
    messageBus.addMessageProcessor(_analyticsService);
    messageBus.addMessageProcessor(this);
  }

  void dispose() {}
}
