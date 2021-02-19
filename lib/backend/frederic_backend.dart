import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:provider/provider.dart';

import 'backend.dart';

class FredericBackend {
  FredericBackend(this._firebaseAuth)
      : _authenticationService = AuthenticationService(_firebaseAuth);

  static FredericBackend of(BuildContext context) {
    return context.read<FredericBackend>();
  }

  final FirebaseAuth _firebaseAuth;
  final AuthenticationService _authenticationService;

  // Streamed objects
  FredericUser currentUser;
  List<FredericGoal> goals;
  List<FredericGoal> achievements;
  HashMap<String, FredericActivity> _activities;

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

  // ===========================================================================
  /// Gets all global activities and the activities of the current user
  ///
  /// Not as versatile as loading activities one by one but much more performant
  ///
  static Future<List<FredericActivity>> getAllActivities(
      [bool loadSets = false]) async {
    CollectionReference activitiesCollection =
        FirebaseFirestore.instance.collection('activities');
    List<FredericActivity> activities = List<FredericActivity>();

    QuerySnapshot snapshot1 = await activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();

    QuerySnapshot snapshot2 =
        await activitiesCollection.where('owner', isEqualTo: 'global').get();

    for (int i = 0; i < snapshot1.docs.length; i++) {
      var map = snapshot1.docs[i];
      FredericActivity a = FredericActivity(map.id);
      a.insertSnapshot(map);
      if (loadSets) await a.loadSets();
      activities.add(a);
    }
    for (int i = 0; i < snapshot2.docs.length; i++) {
      var map = snapshot2.docs[i];
      FredericActivity a = FredericActivity(map.id);
      a.insertSnapshot(map);
      if (loadSets) await a.loadSets();
      activities.add(a);
    }
    return activities;
  }

  // ===========================================================================
  /// Loads all activities the user has access to in a stream
  /// returns a StreamController because the controller has to be closed on dispose
  ///
  static StreamController<List<FredericActivity>> getAllActivitiesStream() {
    CollectionReference activitiesCollection =
        FirebaseFirestore.instance.collection('activities');
    List<FredericActivity> activities = List<FredericActivity>();
    StreamController<List<FredericActivity>> controller =
        StreamController<List<FredericActivity>>();

    Stream<QuerySnapshot> stream1 = activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();
    Stream<QuerySnapshot> stream2 =
        activitiesCollection.where('owner', isEqualTo: 'global').snapshots();

    Stream<QuerySnapshot> stream = StreamGroup.merge([stream1, stream2]);

    stream.listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        var map = event.docs[i];
        FredericActivity a = FredericActivity(map.id);
        a.insertSnapshot(map);
        if (activities.contains(a)) {
          activities.remove(a);
        }
        activities.add(a);
      }
      controller.add(activities);
    });

    return controller;
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
