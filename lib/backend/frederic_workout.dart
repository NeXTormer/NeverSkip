import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/frederic_activity.dart';

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
class FredericWorkout {
  FredericWorkout(this.workoutID,
      {bool shouldLoadActivities = false, bool shouldLoadSets = false}) {
    _loadActivities = shouldLoadActivities;
    _loadSets = shouldLoadSets;
    if (_loadSets && !_loadActivities) _loadSets = false;
  }

  final String workoutID;

  FredericWorkoutActivities _activities;
  StreamController<FredericWorkout> _streamController;
  Stream<FredericWorkout> _broadcastStream;

  DateTime _startDate;
  String _name;
  String _description;
  String _image;
  String _owner;
  String _ownerName;
  bool _isStream = false;
  bool _isFuture = false;
  bool _hasActivitiesLoaded = false;
  bool _hasSetsLoaded = false;
  bool _loadActivities = false;
  bool _loadSets = false;

  FredericWorkoutActivities get activities {
    if (_loadActivities) {
      return _activities;
    }
    print(
        'Error: Attempted to access the activities of a FredericWorkout which has not loaded the activities yet');
    return null;
  }

  String get name => _name ?? 'Empty';
  String get description => _description ?? 'Empty...';
  String get image =>
      _image ?? 'https://via.placeholder.com/400x400?text=noimage';
  String get owner => _owner ?? 'UNKNOWN';
  String get ownerName => _ownerName ?? 'None';
  bool get isStream => _isStream;
  bool get isNotStream => !_isStream;
  bool get hasActivitiesLoaded => _hasActivitiesLoaded;
  bool get hasSetsLoaded => _hasSetsLoaded;
  bool get repeating => _activities.repeating;
  int get period => _activities.period;
  DateTime get startDate => _startDate;

  /// Also updates the name on the Database
  ///
  set name(String value) {
    if (value.isNotEmpty && value != _name) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'name': value});
      if (_isFuture) _name = value;
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
      if (_isFuture) _description = value;
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
      if (_isFuture) _image = value;
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
    if (_isFuture) _activities.period = value;
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
      if (_isFuture) _startDate = value;
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
      if (_isFuture) _activities.repeating = value;
    }
  }

  //============================================================================
  /// Loads data from the DB corresponding to the [workoutID]
  /// returns a future string when done
  ///
  Future<FredericWorkout> loadData() async {
    if (this.workoutID == null) {
      print('[FredericWorkout] Error: workoutID is null');
      return null;
    }
    if (_isStream) {
      print('[FredericWorkout] Error: loadData: already a stream');
      return null;
    }
    _isFuture = true;

    DocumentReference workoutsDocument =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);
    DocumentSnapshot documentSnapshot = await workoutsDocument.get();
    insertSnapshot(documentSnapshot);

    if (_loadActivities) {
      await _loadActivitiesOnce();
    }
    return this;
  }

  //============================================================================
  /// Loads data from the DB corresponding to the [workoutID]
  /// returns a [Stream] of [FredericWorkout]
  ///
  Stream<FredericWorkout> asStream() {
    if (this.workoutID == null) return null;
    if (_isFuture) return null;
    _isStream = true;
    _streamController = StreamController<FredericWorkout>();

    DocumentReference workoutDocument =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);
    Stream<DocumentSnapshot> documentStream = workoutDocument.snapshots();
    documentStream.listen(insertSnapshot);

    if (_loadActivities) {
      _loadActivitiesStream();
    }

    _broadcastStream = _streamController.stream.asBroadcastStream();
    return _broadcastStream;
  }

  //============================================================================
  /// Returns the broadcaststream of the workout
  /// If the workout has not been loaded, it loads the workout first
  ///
  Stream<FredericWorkout> asBroadcastStream() {
    if (_isStream) {
      Future.delayed(Duration(milliseconds: 50), () {
        _streamController.add(this);
      });
      return _broadcastStream;
    } else {
      asStream();
      return asBroadcastStream();
    }
  }

  //============================================================================
  /// If the workout is loaded as a Future, this either reloads or loads the activities,
  /// with sets, or without, based on [loadSets] which is false by default can
  /// be omitted.
  ///
  /// If the workout is loaded as a stream, this adds the activities to the stream,
  /// eihter with sets or without, based on [loadSets]
  ///
  /// To additionally load the sets after this method has been called, use the [loadSets()]
  /// method from [FredericActiivty]
  ///
  Future<void> loadActivities([bool loadSets = false]) async {
    _loadSets |= loadSets;
    if (_isFuture) {
      await _loadActivitiesOnce();
    } else if (_isStream) {
      _loadActivitiesStream();
    } else {
      print(
          '[FredericWorkout] Error: tried loading activities before loading the workout');
    }
  }

  Future<void> _loadActivitiesOnce() async {
    DocumentReference workoutsDocument =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);
    QuerySnapshot activitiesSnapshot =
        await workoutsDocument.collection('activities').get();

    await _processActivityQuerySnapshot(activitiesSnapshot);
  }

  void _loadActivitiesStream() {
    if (_hasActivitiesLoaded) {
      print('[FredericWorkout] Error: tried loading activities twice');
      return;
    }
    DocumentReference workoutDocument =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);
    Stream<QuerySnapshot> queryStream =
        workoutDocument.collection('activities').snapshots();
    queryStream.listen(_processActivityQuerySnapshot);
    _hasActivitiesLoaded = true;
  }

  Future<void> _processActivityQuerySnapshot(QuerySnapshot snapshot) async {
    _activities.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      int weekday = snapshot.docs[i]['weekday'];
      FredericActivity a = FredericActivity(snapshot.docs[i]['activity']);
      a.weekday = weekday;
      _activities.activities[weekday].add(a);
      if (_isStream) {
        a.asStream(_loadSets).listen((event) {
          _updateOutgoingStream();
        });
      } else {
        await a.loadData(_loadSets);
      }
    }
    if (_isStream) {
      _updateOutgoingStream();
    }
    _hasSetsLoaded = _loadSets;
  }

  //============================================================================
  /// TODO: when the workout has a lot of activities with a lot of sets this is
  /// called really often when loading the workout for the first time, maybe bad
  /// for performance.
  /// Maybe stop pause for a few miliseconds after loading?
  ///
  /// 1st fix: dont update stream if one activity is still null (or the name of
  /// the activity is null)
  ///
  void _updateOutgoingStream() {
    bool isFinishedLoading = true;
    if (_activities != null) {
      _activities.activities.forEach((list) {
        list.forEach((element) {
          if (element.isNull) isFinishedLoading = false;
        });
      });
    }
    if (isFinishedLoading) _streamController?.add(this);
  }

  //============================================================================
  /// Takes a DocumentSnapshot and inserts its data into the workout. If the workout
  /// is already loaded as a Stream, the stream is updated after inserting the data
  ///
  void insertSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      _name = 'error loading, snapshot does not exist';
      return;
    }

    _name = snapshot.data()['name'];
    _description = snapshot.data()['description'];
    _image = snapshot.data()['image'];
    _owner = snapshot.data()['owner'];
    _ownerName = snapshot.data()['ownername'];

    int period = snapshot.data()['period'];
    _activities = FredericWorkoutActivities(period);

    _activities.repeating = snapshot.data()['repeating'];
    _startDate = snapshot.data()['startdate'].toDate();

    if (_isStream) {
      _updateOutgoingStream();
    }
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

    if (snapshot.docs.length != 1) return;

    String docID = snapshot.docs[0].id;
    collectionReference.doc(docID).delete();
  }

  @override
  String toString() {
    String s =
        'FredericWorkout[name: $_name, description: $_description, ID: $workoutID, image: $_image, owner: $_owner, ownername: $_ownerName]';
    if (_activities == null) return s;
    for (int i = 0; i < period; i++) {
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
  FredericWorkoutActivities(this.period) {
    _activities = List<List<FredericActivity>>(period + 1);
    for (int i = 0; i < period + 1; i++) {
      activities[i] = List<FredericActivity>();
    }
  }

  int period;
  bool repeating;

  List<List<FredericActivity>> _activities;

  List<List<FredericActivity>> get activities => _activities;
  List<FredericActivity> get everyday => activities[0];

  void clear() {
    for (int i = 0; i < period + 1; i++) {
      activities[i] = List<FredericActivity>();
    }
  }
}
