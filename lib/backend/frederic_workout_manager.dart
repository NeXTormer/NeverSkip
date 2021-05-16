import 'dart:collection';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

///
/// Manages all Workouts. Only one instance of this should exist. Instantiated in
/// [FredericBackend].
///
/// Get a workout using the [] operator, e.g.
/// ```
/// FredericWorkout workout = workoutManager['workoutID'];
/// ```
///
class FredericWorkoutManager with ChangeNotifier {
  FredericWorkoutManager() {
    _workouts = HashMap<String, FredericWorkout?>();
  }

  final CollectionReference _workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

  HashMap<String, FredericWorkout?>? _workouts;
  bool _dataLoaded = false;

  FredericWorkout? operator [](String? value) {
    return _workouts![value!];
  }

  HashMap<String, FredericWorkout?>? get workouts => _workouts;

  ///
  /// Called once in [FredericBackend]
  ///
  void loadData() {
    if (_dataLoaded) return;
    _dataLoaded = true;
    Stream<QuerySnapshot> globalStream =
        _workoutsCollection.where('owner', isEqualTo: 'global').snapshots();
    Stream<QuerySnapshot> userStream = _workoutsCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();

    Stream<QuerySnapshot> streamGroup =
        StreamGroup.merge([globalStream, userStream]);

    streamGroup.listen(_handleWorkoutsStream);
  }

  void _handleWorkoutsStream(QuerySnapshot snapshot) {
    for (int i = 0; i < snapshot.docChanges.length; i++) {
      var docSnapshot = snapshot.docChanges[i].doc;
      if (snapshot.docChanges[i].type == DocumentChangeType.removed) {
        _workouts!.remove(docSnapshot.id);
        continue;
      }

      if (_workouts!.containsKey(docSnapshot.id)) {
        _workouts![docSnapshot.id]!
            .insertSnapshot(snapshot.docChanges[i].doc
                as DocumentSnapshot<Map<String, dynamic>>)
            .notifyListeners();
      } else {
        _workouts![docSnapshot.id] = FredericWorkout(docSnapshot.id)
          ..insertSnapshot(
              docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      }
    }
    notifyListeners();
    print(
        'notify listeners ========================================================');
  }
}
