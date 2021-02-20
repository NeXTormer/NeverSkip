import 'dart:collection';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:provider/provider.dart';

class FredericWorkoutManager with ChangeNotifier {
  FredericWorkoutManager() {
    _workouts = HashMap<String, FredericWorkout>();
  }

  final CollectionReference _workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

  HashMap<String, FredericWorkout> _workouts;
  bool _dataLoaded = false;

  static FredericWorkoutManager of(BuildContext context) =>
      Provider.of<FredericWorkoutManager>(context);

  void loadData() {
    if (_dataLoaded) return;
    _dataLoaded = true;
    Stream<QuerySnapshot> globalStream =
        _workoutsCollection.where('owner', isEqualTo: 'global').snapshots();
    Stream<QuerySnapshot> userStream = _workoutsCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();

    Stream<QuerySnapshot> streamGroup =
        StreamGroup.merge([globalStream, userStream]);

    streamGroup.listen(_handleWorkoutsStream);
  }

  void _handleWorkoutsStream(QuerySnapshot snapshot) {
    bool changed = false;
    for (int i = 0; i < snapshot.docChanges.length; i++) {
      var docSnapshot = snapshot.docChanges[i].doc;
      if (_workouts.containsKey(docSnapshot.id)) {
        _workouts[docSnapshot.id].insertSnapshot(snapshot.docChanges[i].doc);
        changed = true;
      } else {
        _workouts[docSnapshot.id] = FredericWorkout(docSnapshot.id)
          ..insertSnapshot(docSnapshot);
      }
    }
    if (changed) notifyListeners();
  }
}
