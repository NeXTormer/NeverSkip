import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

///
/// Manages all Activities. Only one instance of this should exist. Instantiated in
/// [FredericBackend].
///
/// Get an activity using the [] operator, e.g.
/// ```
/// FredericActivity activity = activityManager['activityID'];
/// ```
///
class FredericActivityManager with ChangeNotifier {
  FredericActivityManager() {
    _activities = HashMap<String, FredericActivity>();
    _hasDataCompleter = Completer<void>();
    _dataLoaded = false;
  }

  late bool _dataLoaded;

  late HashMap<String, FredericActivity> _activities;
  late Completer<void> _hasDataCompleter;

  final CollectionReference _activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  FredericActivity? operator [](String? value) {
    return _activities[value!];
  }

  Iterable<FredericActivity> get activities => _activities.values;

  ///
  /// The futures gets completed if the activities have been loaded
  ///
  /// TODO: not sure if it works multiple times
  ///
  Future<void> hasData() {
    return _hasDataCompleter.future;
  }

  ///
  /// Called once in [FredericBackend]
  ///
  void loadData() {
    if (_dataLoaded) return;
    _dataLoaded = true;
    Stream<QuerySnapshot> globalStream =
        _activitiesCollection.where('owner', isEqualTo: 'global').snapshots();
    Stream<QuerySnapshot> userStream = _activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();

    Stream<QuerySnapshot> streamGroup =
        StreamGroup.merge([globalStream, userStream]);

    streamGroup.listen(_handleActivitiesStream);
  }

  void _handleActivitiesStream(QuerySnapshot snapshot) {
    bool changed = false;
    for (int i = 0; i < snapshot.docChanges.length; i++) {
      var docSnapshot = snapshot.docChanges[i].doc;
      if (_activities.containsKey(docSnapshot.id)) {
        _activities[docSnapshot.id]!
            .insertSnapshot(snapshot.docChanges[i].doc)
            .notifyListeners();
        changed = true;
      } else {
        _activities[docSnapshot.id] = FredericActivity(docSnapshot.id)
          ..insertSnapshot(docSnapshot);
      }
    }
    if (changed) {
      notifyListeners();
    }
    if (!_hasDataCompleter.isCompleted) _hasDataCompleter.complete();
  }

  void updateData() => notifyListeners();
}
