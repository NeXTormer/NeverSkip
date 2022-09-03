import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/analytics/frederic_analytics_service.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/concurrency/frederic_concurrency_message.dart';
import 'package:frederic/backend/database/firebase/firebase_auth_interface.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/purchases/purchase_manager.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
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
import 'database/firebase/firestore_caching_data_interface.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend implements FredericMessageProcessor {
  FredericBackend() {
    _eventBus = FredericMessageBus();
    firestoreInstance = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

    // === User Authentication
    FirebaseAuthInterface firebaseAuthInterface = FirebaseAuthInterface(
        firebaseAuthInstance: firebaseAuthInstance,
        firestoreInstance: firestoreInstance);

    _userManager = FredericUserManager(
        backend: this, authInterface: firebaseAuthInterface);

    _purchaseManager = PurchaseManager(_userManager);

    _activityManager = FredericActivityManager();
    _workoutManager = FredericWorkoutManager(activityManager: _activityManager);

    _setManager = FredericSetManager(_activityManager);
    _goalManager = FredericGoalManager();
    _storageManager = FredericStorageManager(this);
    _analytics = FredericAnalytics();

    _registerEventProcessors();
    _initialize();
  }

  static FredericBackend get instance => getIt<FredericBackend>();

  late final FirebaseFirestore firestoreInstance;

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

  late final PurchaseManager _purchaseManager;

  PurchaseManager get purchaseManager => _purchaseManager;

  final ToastManager toastManager = ToastManager();

  bool get canUseApp => _userManager.state.canUseApp;

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

  Future<void> reloadCachesFromDatabase() async {
    await activityManager.triggerManualFullReload();
    await workoutManager.triggerManualFullReload();
    await setManager.triggerManualFullReload();
    await goalManager.triggerManualFullReload();
  }

  void _initialize() async {
    FredericProfiler.log('Start _initialize');

    Future<void> purchaseManagerFuture = _purchaseManager.initialize();

    await waitUntilUserHasAuthenticated();
    FredericProfiler.log('waitUntilUserHasAuthenticated completed');

    _initializeDefaults(); // no await for faster start times
    _initializeSets();
    await _initializeActivities();
    await _initializeWorkouts();
    _initializeGoals();

    _setManager.initializeDataRepresentations(); // asynchronous

    await purchaseManagerFuture;
    _waitUntilCoreDataHasLoaded.complete();

    FredericProfiler.log('Finished _initialize');
  }

  Future<void> _initializeDefaults() async {
    final data = await _defaultsReference.get();
    _defaults = FredericDefaults(data);

    bool reloadFromDB =
        _userManager.state.shouldReloadFromDB || _defaults!.alwaysReloadFromDB;
    _userManager.state.shouldReloadFromDB = false;
    _userManager.userDataChanged();

    if (reloadFromDB) {
      _activityManager.reload(true);
      _setManager.reload(true);
      _workoutManager.reload(true);
      _goalManager.reload(true);
    }
  }

  Future<void> _initializeActivities() {
    _activityManager.setDataInterface(
        FirestoreCachingDataInterface<FredericActivity>(
            firestoreInstance: firestoreInstance,
            collectionReference: firestoreInstance.collection('activities'),
            name: 'activities',
            generateObject: (id, data) => FredericActivity.fromMap(id, data),
            queries: [
          firestoreInstance
              .collection('activities')
              .where('owner', isEqualTo: 'global'),
          firestoreInstance
              .collection('activities')
              .where('owner', isEqualTo: _userManager.state.id)
        ]));
    return _activityManager.reload();
  }

  Future<void> _initializeWorkouts() {
    _workoutManager
        .setDataInterface(FirestoreCachingDataInterface<FredericWorkout>(
      firestoreInstance: firestoreInstance,
      collectionReference: firestoreInstance.collection('workouts'),
      generateObject: (id, data) {
        final workout = FredericWorkout.fromMap(id, data);
        workout.loadActivities(activityManager);
        return workout;
      },
      name: 'workouts',
      queries: [
        firestoreInstance
            .collection('workouts')
            .where('owner', isEqualTo: 'global'),
        firestoreInstance
            .collection('workouts')
            .where('owner', isEqualTo: _userManager.state.id)
      ],
    ));
    return _workoutManager.reload();
  }

  Future<void> _initializeSets() {
    _setManager.setDataInterface(FirestoreCachingDataInterface(
        name: 'Sets',
        collectionReference: firestoreInstance
            .collection('users')
            .doc(_userManager.state.id)
            .collection('sets'),
        queries: [
          FirebaseFirestore.instance
              .collection('users')
              .doc(_userManager.state.id)
              .collection('sets')
              .orderBy('month')
        ],
        firestoreInstance: firestoreInstance,
        generateObject: (id, data) => FredericSetDocument.fromMap(id, data)));
    return _setManager.reload();
  }

  Future<void> _initializeGoals() {
    _goalManager.setDataInterface(FirestoreCachingDataInterface(
        name: 'Goals',
        collectionReference: FirebaseFirestore.instance
            .collection('users')
            .doc(_userManager.state.id)
            .collection('goals'),
        firestoreInstance: firestoreInstance,
        generateObject: (id, data) => FredericGoal.fromMap(id, data)));

    return _goalManager.reload();
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
          _waitUntilCoreDataHasLoaded.complete();
          break;
        case FredericConcurrencyMessageType.UserHasAuthenticated:
          _waitUntilUserHasAuthenticated.complete();
          break;
        default:
          break;
      }
    }
  }

  void dispose() {
    _purchaseManager.dispose();
  }
}

class FredericDefaults {
  FredericDefaults(DocumentSnapshot<Map<String, dynamic>> document) {
    _featuredActivities =
        document.data()?['featured_activities']?.cast<String>() ??
            const <String>[];
    _alwaysReloadFromDB = document.data()?['always_reload_from_db'];
    _trialDuration = document.data()?['trial_duration'];
  }

  FredericDefaults.empty();

  List<String>? _featuredActivities;
  bool? _alwaysReloadFromDB;
  int? _trialDuration;

  int get trialDuration => _trialDuration ?? 30;

  List<String> get featuredActivities => _featuredActivities ?? <String>[];

  bool get alwaysReloadFromDB => _alwaysReloadFromDB ?? false;
}
