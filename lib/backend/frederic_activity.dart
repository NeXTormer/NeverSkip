import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_set.dart';

///
/// Should only be created/constructed by 'FredericBackend'!
///
/// Activities with the same ID, but a different weekday can exist
///
/// The Weekday is stored as an int, with Monday being 1, ...
/// 0 means everyday
///
/// Changing a property of this class also changes it on the Database
///
/// Users can not view the 'FredericActivity' from other users, therefore
/// the 'FredericActivity' of a Workout contains the current users progress
/// and the methods to modify the progress.
///
/// If the activity is not part of a workout, the 'isSingleActivity' property is true.
///
/// If there is no logged progress form the user the 'hasProgress' property is false.
///
class FredericActivity {
  FredericActivity(this.activityID);

  final String activityID;

  String _name;
  String _description;
  String _image;
  String _owner;
  int _weekday; //maybe don't store weekday in here? we'll see when implementing workout
  int _order;
  List<FredericSet> _sets;

  String get name => _name;
  String get description => _description;
  String get image => _image;
  String get owner => _owner;
  int get weekday => _weekday;
  int get order => _order;
  List<FredericSet> get sets => _sets;

  bool get isSingleActivity {
    return _weekday == null ? true : false;
  }

  bool get hasProgress {
    return _sets == null ? false : true;
  }

  bool get isGlobalActivity {
    return _owner == 'global';
  }

  set name(String value) {}
  set description(String value) {}
  set image(String value) {}
  set weekday(int value) {}
  set order(int value) {}
  set sets(List<FredericSet> value) {}

  Future<void> loadData() async {
    if (activityID == null) return false;

    //load Activity

    DocumentReference activityDocument =
        FirebaseFirestore.instance.collection('activities').doc(activityID);

    DocumentSnapshot snapshot = await activityDocument.get();

    _name = snapshot.data()['name'];
    _description = snapshot.data()['description'];
    _image = snapshot.data()['image'];
    _owner = snapshot.data()['owner'];

    String userid = FirebaseAuth.instance.currentUser.uid;

    CollectionReference activitiyProgressCollection =
        FirebaseFirestore.instance.collection('sets');

    QuerySnapshot progressSnapshot = await activitiyProgressCollection
        .where('user', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .get();

    if (progressSnapshot.docs.length == 0) {
      return;
    }
    _sets = List<FredericSet>();

    for (int i = 0; i < progressSnapshot.docs.length; i++) {
      var map = progressSnapshot.docs[0];
      _sets.add(FredericSet(reps: map['reps'], weight: map['weight']));
    }
  }

  void insertDataBulk() {}

  @override
  String toString() {
    return 'FredericActivity[name: $name, description: $description, owner: $owner]';
  }
}
