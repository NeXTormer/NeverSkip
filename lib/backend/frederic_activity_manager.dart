import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:frederic/backend/backend.dart';
import 'package:provider/provider.dart';

class FredericActivityManager with ChangeNotifier {
  FredericActivityManager() {
    _activities = HashMap<String, FredericActivity>();
  }

  bool _dataLoaded = false;

  HashMap<String, FredericActivity> _activities;

  CollectionReference _activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  operator [](String value) {
    return _activities[value];
  }

  Iterable<FredericActivity> get activities => _activities.values;

  static FredericActivityManager of(BuildContext context) =>
      Provider.of<FredericActivityManager>(context);

  void loadData() {
    if (_dataLoaded) return;
    _dataLoaded = true;
    Stream<QuerySnapshot> globalStream =
        _activitiesCollection.where('owner', isEqualTo: 'global').snapshots();
    Stream<QuerySnapshot> userStream = _activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();

    Stream<QuerySnapshot> streamGroup =
        StreamGroup.merge([globalStream, userStream]);

    streamGroup.listen(handleActivitiesStream);
  }

  void handleActivitiesStream(QuerySnapshot snapshot) {
    bool changed = false;
    for (int i = 0; i < snapshot.docChanges.length; i++) {
      var docSnapshot = snapshot.docChanges[i].doc;
      if (_activities.containsKey(docSnapshot.id)) {
        _activities[docSnapshot.id].insertSnapshot(snapshot.docChanges[i].doc);
        changed = true;
      } else {
        _activities[docSnapshot.id] = FredericActivity(docSnapshot.id)
          ..insertSnapshot(docSnapshot);
      }
    }
    if (changed) notifyListeners();
  }
}
