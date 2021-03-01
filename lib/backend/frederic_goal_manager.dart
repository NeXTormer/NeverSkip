import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'backend.dart';

///
/// Manages all goals. Only one instance of this should exist. Instantiated in
/// [FredericBackend].
///
class FredericGoalManager with ChangeNotifier {
  FredericGoalManager() {
    _allGoals = List<FredericGoal>();
  }

  Stream<QuerySnapshot> _snapshots;

  List<FredericGoal> _allGoals;

  List<FredericGoal> get achievements =>
      _allGoals.where((element) => element.isCompleted).toList();

  List<FredericGoal> get goals =>
      _allGoals.where((element) => element.isNotCompleted).toList();

  ///
  /// Called once in [FredericBackend]
  ///
  void loadData() {
    if (_snapshots != null) return;
    CollectionReference goalsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('goals');
    _snapshots = goalsCollection.snapshots();
    _snapshots.listen(_handleGoalSnapshot);
  }

  void updateData() {
    notifyListeners();
  }

  void _handleGoalSnapshot(QuerySnapshot snapshot) {
    for (var change in snapshot.docChanges) {
      FredericGoal goal = FredericGoal(change.doc.id, this);
      goal.insertData(change.doc);
      if (_allGoals.contains(goal)) _allGoals.remove(goal);
      _allGoals.add(goal);
    }
    notifyListeners();
  }
}
