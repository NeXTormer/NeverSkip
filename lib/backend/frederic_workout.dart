import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';

///
/// Contains all the data for a workout
///
/// A list of activities can either be accessed by [activities.<weekday>] or by
/// [activities.activities(<weekday_id>)]
///
/// All setters perform basic value checks, e.g. if an empty string is passed in,
/// it is ignored
///
/// TODO: add possibility to only load the workout without the activities, to improve
/// performance when viewing a lot of workouts in a list
///
class FredericWorkout with ChangeNotifier {
  FredericWorkout(this.workoutID) {
    _activityManager = FredericBackend.instance().activityManager;
    _activities = FredericWorkoutActivities();
  }

  final String workoutID;
  FredericActivityManager _activityManager;

  FredericWorkoutActivities _activities;

  DateTime _startDate;
  String _name;
  String _description;
  String _image;
  String _owner;
  String _ownerName;
  bool _hasActivitiesLoaded = false;
  bool _canEdit;
  int _periodWeeks;

  DateTime get startDate => _startDate;
  String get name => _name ?? 'Empty';
  String get description => _description ?? 'Empty...';
  String get image =>
      _image ?? 'https://via.placeholder.com/400x400?text=noimage';
  String get owner => _owner ?? 'UNKNOWN';
  String get ownerName => _ownerName ?? ((canEdit ?? false) ? 'You' : 'Other');
  bool get hasActivitiesLoaded => _hasActivitiesLoaded;
  bool get repeating => _activities.repeating;
  bool get canEdit => _canEdit;

  /// period of the workout in weeks
  int get period => _periodWeeks;
  FredericWorkoutActivities get activities {
    if (_hasActivitiesLoaded) {
      return _activities;
    }
    print('Error: activities of workout [$name] not loaded yet');
    return null;
  }

  /// Also updates the name on the Database
  ///
  set name(String value) {
    if (value.isNotEmpty && value != _name) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'name': value});
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
    }
  }

  ///
  /// Also updates the period on the Database
  ///
  set period(int value) {
    if (value > 0 && value != _activities.period) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'period': value});
    }
  }

  ///
  /// Also updates the start date on the Database
  ///
  set startDate(DateTime value) {
    if (value != null && value != _startDate) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'startdate': Timestamp.fromDate(value)});
    }
  }

  ///
  /// Also updates the start date on the Database
  ///
  set repeating(bool value) {
    if (value != null && value != _activities.repeating) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'repeating': value});
    }
  }

  //============================================================================
  /// Creates a new activity using the passed [name], [description], and [image] in the
  /// DB and returns it as a future when finished.
  /// The [owner] is the current user
  ///
  static Future<bool> create(
      {String title,
      String description,
      String image,
      int period,
      bool repeating,
      DateTime startDate}) async {
    CollectionReference workouts =
        FirebaseFirestore.instance.collection('workouts');
    DocumentReference newWorkout = await workouts.add({
      'name': title,
      'description': description,
      'image': image,
      'owner': FirebaseAuth.instance.currentUser.uid,
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

  void loadActivities() {
    if (_hasActivitiesLoaded ?? false) return;
    _hasActivitiesLoaded = true;

    CollectionReference activitiesCollection = FirebaseFirestore.instance
        .collection('workouts')
        .doc(workoutID)
        .collection('activities');
    Stream<QuerySnapshot> queryStream = activitiesCollection.snapshots();
    queryStream.listen(_processActivityQuerySnapshot);
  }

  Future<void> _processActivityQuerySnapshot(QuerySnapshot snapshot) async {
    _activities.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      int weekday = snapshot.docs[i].data()['weekday'];
      String activityID = snapshot.docs[i].data()['activity'];
      if (weekday >= _activities.activities.length) continue;
      _activities.activities[weekday].add(_activityManager[activityID]);
    }
    notifyListeners();
  }

  //============================================================================
  /// Takes a DocumentSnapshot and inserts its data into the workout. If the workout
  /// is already loaded as a Stream, the stream is updated after inserting the data
  ///
  FredericWorkout insertSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()['name'];
    _description = snapshot.data()['description'];
    _image = snapshot.data()['image'];
    _owner = snapshot.data()['owner'];
    _ownerName = snapshot.data()['ownername'];

    _periodWeeks = snapshot.data()['period'];
    _activities.period = (_periodWeeks * 7);
    _activities.repeating = snapshot.data()['repeating'];
    _startDate = snapshot.data()['startdate'].toDate();

    _canEdit = _owner == FirebaseAuth.instance.currentUser.uid;

    return this;
  }

  //============================================================================
  /// Adds an activity to the workout on the specified weekday
  /// Use this to add an activity instead of using activities.add() because
  /// this also adds it to the DB
  ///
  String addActivity(FredericActivity activity, int weekday) {
    List<FredericActivity> list = _activities.activities[weekday];
    if (list.contains(activity)) {
      return 'activity-already-in-list';
    }
    if (_activities.everyday.contains(activity)) {
      return 'activity-already-in-everyday-list';
    }
    list.add(activity);

    _addActivityDB(activity, weekday);
    return 'success';
  }

  //============================================================================
  /// Removes an activity from the workout on the specified weekday
  /// Use this to remove an activity instead of using activities.remove() because
  /// this also removes it on the DB
  ///
  void removeActivity(FredericActivity activity, int weekday) {
    List<FredericActivity> list = _activities.activities[weekday];
    list.remove(activity);
    _removeActivityDB(activity, weekday);
  }

  //============================================================================
  /// Moves the activity to another day in the workout plan
  ///
  void moveActivityToOtherDay(FredericActivity activity, int to) async {
    int fromWeekday = activity.weekday;

    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('workouts')
        .doc(workoutID)
        .collection('activities');

    QuerySnapshot snapshot = await collectionReference
        .where('activity', isEqualTo: activity.activityID)
        .where('weekday', isEqualTo: fromWeekday)
        .get();

    if (snapshot.docs.length != 1) return;

    String docID = snapshot.docs[0].id;
    collectionReference.doc(docID).update({'weekday': to});
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
    String s =
        'FredericWorkout[name: $_name, description: $_description, ID: $workoutID, image: $_image, owner: $_owner, ownername: $_ownerName]';
    if (_activities == null) return s;
    for (int i = 0; i < period * 7; i++) {
      if (_activities.activities[i].isNotEmpty) {
        s += '\n╚> ($i)\n';
      }
      _activities.activities[i].forEach((element) {
        s += '╚=> ' + element.toString() + '\n';
      });
    }
    return s;
  }
}

class FredericWorkoutActivities {
  FredericWorkoutActivities() {
    _activities = List<List<FredericActivity>>();
    _activities.add(List<FredericActivity>());
  }

  int _period = 0;

  /// period of the workout in days
  int get period => _period;

  /// period of the workout in days
  set period(int value) {
    if (value > _period) {
      int diff = value - _period;
      for (int i = 0; i < diff; i++) {
        _activities.add(List<FredericActivity>());
      }
    }
    _period = value;
  }

  bool repeating;

  List<List<FredericActivity>> _activities;

  List<List<FredericActivity>> get activities => _activities;
  List<FredericActivity> get everyday => activities[0];

  void clear() {
    for (int i = 0; i < _activities.length; i++) {
      activities[i] = List<FredericActivity>();
    }
  }
}
