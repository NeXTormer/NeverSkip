import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/analytics/frederic_analytics_service.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/concurrency/frederic_concurrency_message.dart';
import 'package:frederic/backend/database/firestore/firestore_activity_data_interface.dart';
import 'package:frederic/backend/database/firestore/firestore_workout_data_interface.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/storage/frederic_storage_manager.dart';
import 'package:frederic/backend/util/event_bus/frederic_base_message.dart';
import 'package:frederic/backend/util/event_bus/frederic_message_bus.dart';
import 'package:frederic/backend/util/event_bus/frederic_message_processor.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/backend/util/toast_manager.dart';
import 'package:frederic/backend/util/wait_for_x.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend extends FredericMessageProcessor {
  FredericBackend() {
    _eventBus = FredericMessageBus();
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    _userManager = FredericUserManager(backend: this);

    // === Activities
    _activityManager = FredericActivityManager(
        dataInterface: FirestoreActivityDataInterface(
            firestoreInstance: firestoreInstance,
            activitiesCollection: firestoreInstance.collection('activities')));

    _setManager = FredericSetManager();

    // === Workouts
    _workoutManager = FredericWorkoutManager(
        activityManager: _activityManager,
        dataInterface: FirestoreWorkoutDataInterface(
            firestoreInstance: firestoreInstance,
            workoutsCollection: firestoreInstance.collection('workouts')));

    _goalManager = FredericGoalManager();

    _storageManager = FredericStorageManager(this);

    _analytics = FredericAnalytics();

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

  late final FredericAnalytics _analytics;
  FredericAnalytics get analytics => _analytics;

  final ToastManager toastManager = ToastManager();

  WaitForX _waitUntilCoreDataHasLoaded = WaitForX();
  Future<void> waitUntilCoreDataIsLoaded() =>
      _waitUntilCoreDataHasLoaded.waitForX();

  WaitForX _waitUntilUserHasAuthenticated = WaitForX();
  Future<void> waitUntilUserHasAuthenticated() =>
      _waitUntilUserHasAuthenticated.waitForX();

  FredericDefaults? _defaults;
  FredericDefaults get defaults => _defaults ?? FredericDefaults.empty();
  DocumentReference<Map<String, dynamic>> _defaultsReference =
      FirebaseFirestore.instance.collection('defaults').doc('defaults');

  void loadData() async {
    var profiler = FredericProfiler.track('FredericBackend::loadData()');

    await waitUntilUserHasAuthenticated();

    _defaults = FredericDefaults(await _defaultsReference.get());

    _setManager.reload();
    await _activityManager.reload();
    await _workoutManager.reload();
    await _goalManager.reload();

    _waitUntilCoreDataHasLoaded.complete();
    profiler.stop();
  }

  void _registerEventProcessors() {
    messageBus.addMessageProcessor(this);
  }

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

  void dispose() {}
}

class FredericDefaults {
  FredericDefaults(DocumentSnapshot<Map<String, dynamic>> document) {
    _featuredActivities =
        document.data()?['featured_activities']?.cast<String>() ??
            const <String>[];
  }

  FredericDefaults.empty();

  List<String>? _featuredActivities;
  List<String> get featuredActivities => _featuredActivities ?? <String>[];
}
