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
    _allGoals = <FredericGoal>[];
  }

  Stream<QuerySnapshot>? _snapshots;

  late List<FredericGoal> _allGoals;

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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('goals');
    _snapshots = goalsCollection.snapshots();
    _snapshots!
        .listen(_handleGoalSnapshot as void Function(QuerySnapshot<Object?>)?);
  }

  void updateData() {
    notifyListeners();
  }

  void _handleGoalSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var goal in _allGoals) {
      goal.discard();
    }
    _allGoals.clear();
    for (var doc in snapshot.docs) {
      FredericGoal goal = FredericGoal(doc.id, this);
      goal.insertData(doc);
      //goal.activity?.loadSets();
      _allGoals.add(goal);
    }
    notifyListeners();
  }
}
