import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

class FredericBackend {
  FredericBackend() {
    _authenticationService = AuthenticationService(FirebaseAuth.instance);
  }

  AuthenticationService _authenticationService;

  FredericActivityManager _activityManager;
  FredericActivityManager get activityManager => _activityManager;

  FredericWorkoutManager _workoutManager;
  FredericWorkoutManager get workoutManager => _workoutManager;

  // Streamed objects
  FredericUser _currentUser;
  FredericUser get currentUser => _currentUser;
  List<FredericGoal> goals;
  List<FredericGoal> achievements;

  // Streams and StreamControllers
  Stream<FredericUser> _currentUserStream;

  StreamController<FredericUser> _currentUserStreamController;
  StreamController<List<FredericGoal>> _goalsStreamController;
  StreamController<List<FredericGoal>> _achievementsStreamController;

  Stream<FredericUser> get currentUserStream => _currentUserStream;
  AuthenticationService get authService => _authenticationService;

  ///
  /// Use this to load the data for the currentUser, instead of using
  /// currentUser.loadData().
  ///
  Future<FredericUser> loadCurrentUser() async {
    await currentUser.loadData();
    _currentUserStreamController = StreamController<FredericUser>();
    _currentUserStream =
        _currentUserStreamController.stream.asBroadcastStream();
    _loadCurrentUserStream();
    return currentUser;
  }

  void loadData() {
    _activityManager = FredericActivityManager();
    _activityManager.loadData();

    _workoutManager = FredericWorkoutManager();
    _workoutManager.loadData();
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

  Stream<List<FredericGoal>> loadAchievementsStream() {
    if (_achievementsStreamController != null)
      return _achievementsStreamController.stream;
    CollectionReference goalsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('goals');
    Stream<QuerySnapshot> snapshots =
        goalsCollection.where('iscompleted', isEqualTo: true).snapshots();
    achievements = List<FredericGoal>();
    _achievementsStreamController = StreamController<List<FredericGoal>>();
    snapshots.listen(_processAchievementStream);
    return _achievementsStreamController.stream;
  }

  void _processAchievementStream(QuerySnapshot snapshot) {
    achievements.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      var data = snapshot.docs[i];
      FredericGoal achievement = FredericGoal(data.id);
      achievement.insertData(data);

      achievements.add(achievement);
    }

    _achievementsStreamController.add(achievements);
  }

  Stream<List<FredericGoal>> loadGoalStream() {
    if (_goalsStreamController != null) return _goalsStreamController.stream;
    CollectionReference goalsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('goals');
    Stream<QuerySnapshot> snapshots =
        goalsCollection.where('iscompleted', isEqualTo: false).snapshots();
    goals = List<FredericGoal>();
    _goalsStreamController = StreamController<List<FredericGoal>>();
    snapshots.listen(_processGoalStream);
    return _goalsStreamController.stream;
  }

  void _processGoalStream(QuerySnapshot snapshot) {
    goals.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      var data = snapshot.docs[i];
      FredericGoal goal = FredericGoal(data.id);
      goal.insertData(data);

      goals.add(goal);
    }

    reloadGoalProgress();
    //_goalsStreamController.add(goals); // already done in [reloadGoalProgress()]
  }

  void reloadGoalProgress([int limit = 5]) async {
    CollectionReference setsCollection =
        FirebaseFirestore.instance.collection('sets');
    for (int i = 0; i < goals.length; i++) {
      FredericGoal goal = goals[i];
      if (goal.isCompleted) continue;
      QuerySnapshot snapshot = await setsCollection
          .where('owner', isEqualTo: currentUser.uid)
          .where('activity', isEqualTo: goal.activityID)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      goal.sets.clear();
      for (int j = 0; j < snapshot.docs.length; j++) {
        var data = snapshot.docs[j].data();
        goal.sets.add(FredericSet(snapshot.docs[j].id, data['reps'],
            data['weight'], data['timestamp'].toDate()));
        goal.calculateCurrentProgress();
      }
    }
    _goalsStreamController.add(goals);
  }
}
