import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    _authenticationService = AuthenticationService(FirebaseAuth.instance);
    _activityManager = FredericActivityManager();
    _workoutManager = FredericWorkoutManager();
    _goalManager = FredericGoalManager();
  }

  AuthenticationService _authenticationService;
  AuthenticationService get authService => _authenticationService;

  FredericActivityManager _activityManager;
  FredericActivityManager get activityManager => _activityManager;

  FredericWorkoutManager _workoutManager;
  FredericWorkoutManager get workoutManager => _workoutManager;

  FredericGoalManager _goalManager;
  FredericGoalManager get goalManager => _goalManager;

  FredericUser _currentUser;
  FredericUser get currentUser => _currentUser;

  Stream<FredericUser> _currentUserStream;
  Stream<FredericUser> get currentUserStream => _currentUserStream;

  StreamController<FredericUser> _currentUserStreamController;

  static FredericBackend instance() => getIt<FredericBackend>();

  ///
  /// Use this to load the data for the currentUser, instead of using
  /// currentUser.loadData().
  ///
  /// Normally called in AuthenticationWrapper
  ///
  Future<FredericUser> loadCurrentUser() async {
    await currentUser.loadData();
    _currentUserStreamController = StreamController<FredericUser>.broadcast();
    _currentUserStream = _currentUserStreamController.stream;
    _loadCurrentUserStream();

    return currentUser;
  }

  void loadData() {
    _activityManager.loadData();
    _workoutManager.loadData();
    _goalManager.loadData();
  }

  void logIn(String uid) {
    _currentUser = FredericUser(uid);
  }

  void _loadCurrentUserStream() {
    if (currentUser?.uid == null) return null;

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    Stream<DocumentSnapshot> userStream =
        usersCollection.doc(currentUser.uid).snapshots();

    userStream.listen((event) {
      currentUser.insertDocumentSnapshot(event);
      _currentUserStreamController.add(currentUser);
    });
  }

  //TODO: Call this on app close
  void dispose() {
    _activityManager.dispose();
    _workoutManager.dispose();
    _goalManager.dispose();
  }
}
