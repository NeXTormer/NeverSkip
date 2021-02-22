import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_set.dart';

///
/// Contains a snapshot of a users progress in a certain activity. Can either be
/// a weight or a number of reps. The snapshot types are minimum, maximum or average.
/// By default, the last 10 sets are loaded to calculate the snapshot value. Change
/// the argument [setsLimit] in the constructor to load more or less.
///
class FredericProgressSnapshot {
  FredericProgressSnapshot(this.activityID, this.goalType, this.snapshotType,
      [int setsLimit = 10]) {
    if (setsLimit > 0)
      this.limit = setsLimit;
    else
      this.limit = 1;

    activity = FredericBackend.instance().activityManager[activityID];
  }

  FredericGoalType goalType;
  FredericProgressSnapshotType snapshotType;
  FredericActivity activity;
  String activityID;
  int limit;

  StreamController<num> _streamController;
  List<FredericSet> _sets = List<FredericSet>();

  num value;

  String get activityName {
    return activity?.name ?? 'Loading...';
  }

  void _processSnapshot(QuerySnapshot snapshot) {
    for (int j = 0; j < snapshot.docs.length; j++) {
      var data = snapshot.docs[j].data();
      _sets.add(FredericSet(snapshot.docs[j].id, data['reps'], data['weight'],
          data['timestamp'].toDate()));
    }
    _calculateCurrentProgress();
    _streamController.add(value);
  }

  void _calculateCurrentProgress() {
    num max = 0;
    if (goalType == FredericGoalType.Weight) {
      _sets.forEach((element) {
        max = element.weight > max ? element.weight : max;
      });
    } else if (goalType == FredericGoalType.Reps) {
      _sets.forEach((element) {
        max = element.reps > max ? element.reps : max;
      });
    }
    value = max;
  }

  Stream<num> asStream() {
    Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
        .collection('sets')
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
    _streamController = StreamController<num>();
    snapshots.listen(_processSnapshot);

    return _streamController.stream;
  }
}

enum FredericProgressSnapshotType {
  Maximum,
  Minimum,
  Average,
}
