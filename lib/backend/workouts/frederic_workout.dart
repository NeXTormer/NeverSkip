import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';

///
/// Contains all the data for a workout.
///
/// Setters also change the values in the database.
///
/// The period of a workout is represented in weeks.
///
/// Must call loadActivities to load the activities.
///
///
class FredericWorkout {
  FredericWorkout(DocumentSnapshot<Object?> snapshot, this._workoutManager)
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
    _startDate = data['startdate']?.toDate();
    _activitiesList = data['activities'];

    _activities = FredericWorkoutActivities(this);
  }

  FredericWorkout.create()
      : workoutID = 'new',
        _workoutManager = FredericBackend.instance.workoutManager {
    _activities = FredericWorkoutActivities(this);
  }

  final String workoutID;
  final FredericWorkoutManager _workoutManager;

  late FredericWorkoutActivities _activities;
  List<dynamic>? _activitiesList;

  DateTime? _startDate;
  String? _name;
  String? _description;
  String? _image;
  String? _owner;
  String? _ownerName;
  int? _period;
  bool? _repeating;

  DateTime get startDate => _startDate ?? DateTime.now();
  DateTime get startDateAdjusted {
    DateTime today = DateTime.now();
    DateTime end = startDate.add(Duration(days: period * 7));
    if (today.isAfter(end) && repeating == false) return startDate;
    return today.subtract(
        Duration(days: today.difference(startDate).inDays % (period * 7)));
  }

  String get name => _name ?? 'Workout name';
  String get description => _description ?? 'Workout description';
  String get image =>
      _image ??
      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fpush-up.png?alt=media&token=60cfa88e-4777-46fe-8005-5263c490c109';
  String get owner => _owner ?? 'No owner';
  String get ownerName => _ownerName ?? (canEdit ? 'You' : 'Other');

  bool get repeating => _repeating ?? false;
  bool get canEdit => owner == FirebaseAuth.instance.currentUser?.uid;

  /// period of the workout in weeks
  int get period => _period ?? 1;

  FredericWorkoutActivities get activities => _activities;

  set name(String value) {
    if (value.isNotEmpty && value != _name) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'name': value});
      _name = value;
      _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    }
  }

  set description(String value) {
    if (value.isNotEmpty && value != _description) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'description': value});
      _description = value;
      _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    }
  }

  set image(String value) {
    if (value.isNotEmpty && value != _image) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'image': value});
      _image = value;
      _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    }
  }

  set period(int value) {
    if (value > 0 && value != period) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'period': value});
      _period = value;
      _activities.resizeForPeriod(value);
      _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    }
  }

  set startDate(DateTime value) {
    if (value != _startDate) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'startdate': Timestamp.fromDate(value)});
      _startDate = value;
      _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    }
  }

  set repeating(bool value) {
    if (value != _activities.repeating) {
      FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutID)
          .update({'repeating': value});
      _repeating = value;
      _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    }
  }

  Future<void> loadActivities() async {
    if (_activitiesList == null) return;
    for (dynamic activityMap in _activitiesList!) {
      String? id = activityMap['activityid'];
      num? weekdayRaw = activityMap['weekday'];
      int weekday =
          weekdayRaw?.toInt() ?? period * 100; // to make the if fail when null

      if (weekday <= period * 7 && id != null) {
        _activities.activities[weekday].add(FredericWorkoutActivity.fromMap(
            await FredericBackend.instance.activityManager.getActivity(id),
            activityMap));
      }
    }

    for (var list in _activities.activities) list.sort();

    _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
    return;
  }

  //============================================================================
  /// Saves the workout to the database. Only use when created with
  /// FredericWorkout.create()
  ///
  void save(
      {required String title,
      required String description,
      required String image,
      required int period,
      required bool repeating,
      required DateTime startDate}) async {
    if (workoutID != 'new') return;
    CollectionReference workouts =
        FirebaseFirestore.instance.collection('workouts');
    var newWorkout = await workouts.add({
      'name': title,
      'description': description,
      'image': image,
      'owner': FirebaseAuth.instance.currentUser?.uid,
      'period': period,
      'repeating': repeating,
      'startdate': Timestamp.fromDate(startDate)
    });
    var snapshot = await newWorkout.get();
    _workoutManager.add(
        FredericWorkoutCreateEvent(FredericWorkout(snapshot, _workoutManager)));
  }

  ///
  /// Deletes the workout from the DB, don't call directly
  ///
  void delete() {
    FirebaseFirestore.instance.collection('workouts').doc(workoutID).delete();
  }

  //============================================================================
  /// Adds an activity to the workout on the specified weekday
  /// Use this to add an activity instead of using activities.add() because
  /// this also adds it to the DB
  ///
  bool addActivity(FredericWorkoutActivity activity) {
    if (_activities.activities[activity.weekday].contains(activity)) {
      return false;
    }
    if (_activities.everyday.contains(activity)) {
      return false;
    }
    _activities.activities[activity.weekday]
        .add(activity..order = _activities.activities[activity.weekday].length);
    updateActivitiesInDB();
    return true;
  }

  //============================================================================
  /// Removes an activity from the workout on the specified weekday
  /// Use this to remove an activity instead of using activities.remove() because
  /// this also removes it on the DB
  ///
  void removeActivity(FredericWorkoutActivity activity, int weekday) {
    _activities.activities[weekday].remove(activity);
    updateOrderOfActivities(weekday);
    updateActivitiesInDB();
  }

  void swapDays(int first, int second) {
    first++;
    second++;
    bool someChanges = false;
    List<FredericWorkoutActivity> firstActivities =
        _activities.activities[first].toList();
    _activities.activities[first] = _activities.activities[second].toList();
    _activities.activities[second] = firstActivities;

    _activities.activities[first].forEach((element) {
      element.changeWeekday(first);
      someChanges = true;
    });

    _activities.activities[second].forEach((element) {
      element.changeWeekday(second);
      someChanges = true;
    });
    if (someChanges) {
      updateActivitiesInDB();
    }
  }

  void changeOrderOfActivity(int weekday, int oldIndex, int newIndex) {
    List<FredericWorkoutActivity> list = _activities.activities[weekday];

    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final activity = list.removeAt(oldIndex);
    updateOrderOfActivities(weekday);
    list.insert(newIndex, activity);

    updateActivitiesInDB();
  }

  void updateOrderOfActivities(int weekday) {
    List<FredericWorkoutActivity> list = _activities.activities[weekday];
    for (int i = 0; i < list.length; i++) {
      list[i].order = i;
    }
  }

  void updateActivitiesInDB() {
    DocumentReference workoutReference =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    workoutReference.update({'activities': _activities.toList()});

    _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
  }

  @override
  String toString() {
    return 'FredericWorkout[name: $_name, ID: $workoutID]';
  }
}

class FredericWorkoutActivities {
  FredericWorkoutActivities(this.workout)
      : _activities = <List<FredericWorkoutActivity>>[] {
    _activities.add(<FredericWorkoutActivity>[]);

    while (_activities.length <= ((workout.period * 7) + 1)) {
      _activities.add(<FredericWorkoutActivity>[]);
    }
  }

  final FredericWorkout workout;

  int get period => workout.period;
  bool get repeating => workout.repeating;

  List<List<FredericWorkoutActivity>> _activities;

  List<List<FredericWorkoutActivity>> get activities => _activities;
  List<FredericWorkoutActivity> get everyday => activities[0];

  void resizeForPeriod(int value) {
    while (_activities.length <= ((value * 7))) {
      _activities.add(<FredericWorkoutActivity>[]);
    }
  }

  List<FredericWorkoutActivity> getDay(DateTime day) {
    DateTime start = workout.startDate;
    DateTime end = workout.startDate.add(Duration(days: period * 7));
    if (day.isAfter(end) && workout.repeating == false)
      return <FredericWorkoutActivity>[];
    int daysDiff = day.difference(start).inDays % (period * 7);
    return activities[daysDiff + 1];
  }

  int getDayIndex(DateTime day) {
    DateTime start = workout.startDate;
    DateTime end = workout.startDate.add(Duration(days: period * 7));
    if (day.isAfter(end) && workout.repeating == false) return -1;
    return day.difference(start).inDays % (period * 7);
  }

  List<Map<String, dynamic>> toList() {
    List<Map<String, dynamic>> list = <Map<String, dynamic>>[];
    for (int weekday = 0; weekday <= period * 7; weekday++) {
      for (FredericWorkoutActivity activityInList in _activities[weekday]) {
        list.add(activityInList.toMap());
      }
    }
    return list;
  }

  void clear() {
    for (int i = 0; i < _activities.length; i++) {
      activities[i] = <FredericWorkoutActivity>[];
    }
  }
}
