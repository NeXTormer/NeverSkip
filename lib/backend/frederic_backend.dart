import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

class FredericBackend {
  FredericBackend() {
    _authenticationService = AuthenticationService(FirebaseAuth.instance);
    _activityManager = FredericActivityManager();
    _workoutManager = FredericWorkoutManager();
    _goalManager = FredericGoalManager();
  }

  AuthenticationService _authenticationService;

  FredericActivityManager _activityManager;
  FredericActivityManager get activityManager => _activityManager;

  FredericWorkoutManager _workoutManager;
  FredericWorkoutManager get workoutManager => _workoutManager;

  FredericGoalManager _goalManager;
  FredericGoalManager get goalManager => _goalManager;

  // Streamed objects
  FredericUser _currentUser;
  FredericUser get currentUser => _currentUser;
  List<FredericGoal> goals;
  List<FredericGoal> achievements;

  // Streams and StreamControllers
  Stream<FredericUser> _currentUserStream;

  StreamController<FredericUser> _currentUserStreamController;

  Stream<FredericUser> get currentUserStream => _currentUserStream;
  AuthenticationService get authService => _authenticationService;

  ///
  /// Use this to load the data for the currentUser, instead of using
  /// currentUser.loadData().
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

  static FredericBackend instance() => getIt<FredericBackend>();

  void _loadCurrentUserStream() {
    if (currentUser?.uid == null) {
      return null;
    }

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    Stream<DocumentSnapshot> userStream =
        usersCollection.doc(currentUser.uid).snapshots();

    userStream.listen((event) {
      currentUser.insertDocumentSnapshot(event);
      _currentUserStreamController.add(currentUser);
    });
  }

  void dispose() {
    _activityManager.dispose();
    _workoutManager.dispose();
  }
}
