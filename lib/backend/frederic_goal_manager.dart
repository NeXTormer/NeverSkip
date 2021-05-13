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

  Stream<QuerySnapshot<Map<String, dynamic>>>? _snapshots;

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
    if (FirebaseAuth.instance.currentUser == null) return;
    CollectionReference<Map<String, dynamic>> goalsCollection =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('goals');
    _snapshots = goalsCollection.snapshots();
    _snapshots!.listen(_handleGoalSnapshot);
  }

  void updateData() {
    notifyListeners();
  }

  void _handleGoalSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    _allGoals.clear();
    for (var doc in snapshot.docs) {
      FredericGoal goal = FredericGoal(doc.id);
      goal.insertData(doc);
      _allGoals.add(goal);
      //load activity goal.activityID
    }
    notifyListeners();
  }
}
