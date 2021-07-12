import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/backend.dart';

///
/// Contains all the data for a workout
///
/// Setters also change the values in the database
///
/// The period of a workout is represented in weeks
///
class FredericWorkout with ChangeNotifier {
  FredericWorkout(DocumentSnapshot<Object?> snapshot)
      : workoutID = snapshot.id {
    var data = (snapshot as DocumentSnapshot<Map<String, dynamic>?>).data();
    if (data == null) return;

    _name = data['name'];
    _description = data['description'];
    _image = data['image'];
    _owner = data['owner'];
    _ownerName = data['ownername'];
    _period = data['period'];
    _repeating = data['repeating'];
    _startDate = data['startdate'].toDate();

    _activities = FredericWorkoutActivities(this);
  }

  final String workoutID;

  late FredericWorkoutActivities _activities;

  DateTime? _startDate;
  String? _name;
  String? _description;
  String? _image;
  String? _owner;
  String? _ownerName;
  int? _period;
  bool? _repeating;

  DateTime get startDate => _startDate ?? DateTime.now();
  String get name => _name ?? 'Empty workout';
  String get description => _description ?? 'Empty...';
  String get image =>
      _image ?? 'https://via.placeholder.com/400x400?text=noimage';
  String get owner => _owner ?? 'No owner';
  String get ownerName => _ownerName ?? (canEdit ? 'You' : 'Other');

  bool get repeating => _repeating ?? false;
  bool get canEdit => owner == FirebaseAuth.instance.currentUser?.uid;

  /// period of the workout in weeks
  int get period => _period ?? 1;

  FredericWorkoutActivities get activities => _activities;

  /// Also updates the name on the Database
  ///
  set name(String value) {
    if (value.isNotEmpty && value != _name) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'name': value});
      _name = value;
    }
  }

  ///
  /// Also updates the description on the Database
  ///
  set description(String value) {
    if (value.isNotEmpty && value != _description) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'description': value});
      _description = value;
    }
  }

  ///
  /// Also updates the image on the Database
  ///
  set image(String value) {
    if (value.isNotEmpty && value != _image) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'image': value});
      _image = value;
    }
  }

  ///
  /// Also updates the period on the Database
  ///
  set period(int value) {
    if (value > 0 && value != period) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'period': value});
      _period = value;
    }
  }

  ///
  /// Also updates the start date on the Database
  ///
  set startDate(DateTime value) {
    if (value != _startDate) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'startdate': Timestamp.fromDate(value)});
      _startDate = value;
    }
  }

  ///
  /// Also updates the start date on the Database
  ///
  set repeating(bool value) {
    if (value != _activities.repeating) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'repeating': value});
      _repeating = value;
    }
  }

  //============================================================================
  /// Creates a new activity using the passed [name], [description], and [image] in the
  /// DB and returns it as a future when finished.
  /// The [owner] is the current user
  ///
  @deprecated
  static Future<bool> create(
      {String? title,
      String? description,
      String? image,
      int? period,
      bool? repeating,
      required DateTime startDate}) async {
    CollectionReference workouts =
        FirebaseFirestore.instance.collection('workouts');
    DocumentReference newWorkout = await workouts.add({
      'name': title,
      'description': description,
      'image': image,
      'owner': FirebaseAuth.instance.currentUser?.uid,
      'period': period,
      'repeating': repeating,
      'startdate': Timestamp.fromDate(startDate)
    });
    return true;
  }

  ///
  /// Deletes the workout from the DB
  ///
  void delete() {
    FirebaseFirestore.instance.collection('workouts').doc(workoutID).delete();
  }

  //============================================================================
  /// Adds an activity to the workout on the specified weekday
  /// Use this to add an activity instead of using activities.add() because
  /// this also adds it to the DB
  ///
  bool addActivity(FredericActivity activity, int weekday) {
    List<FredericActivity?> list = _activities.activities[weekday];
    if (list.contains(activity)) {
      return false;
    }
    if (_activities.everyday.contains(activity)) {
      return false;
    }
    list.add(activity);

    _addActivityDB(activity, weekday);
    return true;
  }

  //============================================================================
  /// Removes an activity from the workout on the specified weekday
  /// Use this to remove an activity instead of using activities.remove() because
  /// this also removes it on the DB
  ///
  void removeActivity(FredericActivity activity, int weekday) {
    List<FredericActivity?> list = _activities.activities[weekday];
    list.remove(activity);
    _removeActivityDB(activity, weekday);
  }

  void _addActivityDB(FredericActivity activity, int day) {
    DocumentReference workoutReference =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    workoutReference
        .collection('activities')
        .add({'activity': activity.activityID, 'weekday': day});
  }

  Future<void> _removeActivityDB(FredericActivity activity, int day) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('workouts')
        .doc(workoutID)
        .collection('activities');

    QuerySnapshot snapshot = await collectionReference
        .where('activity', isEqualTo: activity.activityID)
        .where('weekday', isEqualTo: day)
        .get();

    if (snapshot.docs.length == 0) return;

    String docID = snapshot.docs[0].id;
    collectionReference.doc(docID).delete();
  }

  @override
  String toString() {
    return 'FredericWorkout[name: $_name, ID: $workoutID]';
  }
}

class FredericWorkoutActivities {
  FredericWorkoutActivities(this.workout)
      : _activities = <List<FredericActivity>>[] {
    _activities.add(<FredericActivity>[]);

    while (_activities.length <= ((workout.period * 7) + 1)) {
      _activities.add(<FredericActivity>[]);
    }
  }

  final FredericWorkout workout;

  int get period => workout.period;
  bool get repeating => workout.repeating;

  List<List<FredericActivity>> _activities;

  List<List<FredericActivity>> get activities => _activities;
  List<FredericActivity> get everyday => activities[0];

  void resizeForPeriod(int value) {
    if (value > period) {
      num diff = (value - period) * 7;
      while (_activities.length <= (diff + 1)) {
        _activities.add(<FredericActivity>[]);
      }
    }
  }

  List<FredericActivity> getDay(DateTime day) {
    if (workout.startDate == null) return <FredericActivity>[];
    DateTime start = workout.startDate!
        .subtract(Duration(days: workout.startDate!.weekday - 1));
    DateTime end = workout.startDate!.add(Duration(days: period));
    if (day.isAfter(end) && workout.repeating == false)
      return <FredericActivity>[];
    int daysdiff = day.difference(start).inDays % period;
    return activities[daysdiff + 1] + activities[0];
  }

  void clear() {
    for (int i = 0; i < _activities.length; i++) {
      activities[i] = <FredericActivity>[];
    }
  }
}
