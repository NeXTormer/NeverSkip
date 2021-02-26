import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'backend.dart';

class FredericGoalManager with ChangeNotifier {
  FredericGoalManager() {
    _allGoals = List<FredericGoal>();
  }

  List<FredericGoal> _allGoals;

  List<FredericGoal> get achievements =>
      _allGoals.where((element) => element.isCompleted).toList();

  List<FredericGoal> get goals =>
      _allGoals.where((element) => element.isNotCompleted).toList();

  void loadData() {
    CollectionReference goalsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('goals');
    Stream<QuerySnapshot> snapshots = goalsCollection.snapshots();
    snapshots.listen(_handleGoalSnapshot);
  }

  void updateData() {
    notifyListeners();
  }

  void _handleGoalSnapshot(QuerySnapshot snapshot) {
    for (var change in snapshot.docChanges) {
      FredericGoal goal = FredericGoal(change.doc.id, this);
      if (_allGoals.contains(goal)) _allGoals.remove(goal);
      _allGoals.add(goal);
    }
    updateData();
  }
}
