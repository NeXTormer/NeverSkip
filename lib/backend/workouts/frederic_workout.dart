import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/backend.dart';

///
/// Contains all the data for a workout
///
/// Setters also change the values in the database
///
/// The period of a workout is represented in weeks
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
    List<dynamic>? activitiesList = data['activities'];

    _activities = FredericWorkoutActivities(this);
    _loadActivities(activitiesList);
  }

  FredericWorkout.create()
      : workoutID = 'new',
        _workoutManager = FredericBackend.instance.workoutManager {
    _activities = FredericWorkoutActivities(this);
  }

  final String workoutID;
  final FredericWorkoutManager _workoutManager;

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

  void _loadActivities(List<dynamic>? activitiesList) async {
    if (activitiesList == null) return;
    for (dynamic activity in activitiesList) {
      String? id = activity['activityid'];
      num? weekday = activity['weekday'];
      int wd = weekday?.toInt() ?? period * 10; // to make the if fail when null
      if (wd <= period * 7 && id != null) {
        _activities.activities[wd].add(
            await FredericBackend.instance.activityManager.getActivity(id));
      }
    }
    _workoutManager.add(FredericWorkoutUpdateEvent(workoutID));
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
  bool addActivity(FredericActivity activity, int weekday) {
    if (_activities.activities[weekday].contains(activity)) {
      return false;
    }
    if (_activities.everyday.contains(activity)) {
      return false;
    }
    _activities.activities[weekday].add(activity);
    _updateActivitiesInDB();
    return true;
  }

  //============================================================================
  /// Removes an activity from the workout on the specified weekday
  /// Use this to remove an activity instead of using activities.remove() because
  /// this also removes it on the DB
  ///
  void removeActivity(FredericActivity activity, int weekday) {
    _activities.activities[weekday].remove(activity);
    _updateActivitiesInDB();
  }

  void _updateActivitiesInDB() {
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
    DateTime start = workout.startDate;
    DateTime end = workout.startDate.add(Duration(days: period * 7));
    if (day.isAfter(end) && workout.repeating == false)
      return <FredericActivity>[];
    int daysDiff = day.difference(start).inDays % (period * 7);
    return activities[daysDiff + 1] + activities[0];
  }

  List<Map<String, dynamic>> toList() {
    List<Map<String, dynamic>> list = <Map<String, dynamic>>[];
    for (int weekday = 0; weekday <= period * 7; weekday++) {
      for (FredericActivity activityInList in _activities[weekday]) {
        list.add({'weekday': weekday, 'activityid': activityInList.activityID});
      }
    }
    return list;
  }

  void clear() {
    for (int i = 0; i < _activities.length; i++) {
      activities[i] = <FredericActivity>[];
    }
  }
}
