import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
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
class FredericWorkout implements FredericDataObject {
  FredericWorkout.fromMap(String id, Map<String, dynamic> data) {
    fromMap(id, data);
    _activities = FredericWorkoutActivities(this);
  }

  FredericWorkout.noSuchWorkout(String id)
      : this.id = id,
        _name = 'No Such Workout found',
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fquestion-mark.png?alt=media&token=b9b9a58c-1a9c-4b2c-8ae0-a8e7245baa9a' {
    _activities = FredericWorkoutActivities(this);
  }

  FredericWorkout.create()
      : id = '',
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fworkout-plan-4234.png?alt=media&token=890d0a5c-93ac-41a0-bd05-b3626b8e0d82',
        _owner = FredericBackend.instance.userManager.state.id {
    _activities = FredericWorkoutActivities(this);
  }

  late final String id;

  late FredericWorkoutActivities _activities;
  void Function(FredericWorkout)? onUpdate;

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

  String get name => _name ?? 'New Workout';
  String get description => _description ?? 'Workout description';
  String get image =>
      _image ??
      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Floading.png?alt=media&token=4f99ab1f-c0bb-4881-b010-4c395b3206a1';
  String get owner => _owner ?? 'No owner';
  String get ownerName => _ownerName ?? (canEdit ? 'You' : 'Other');

  bool get repeating => _repeating ?? false;

  // TODO: remove call to FirebaseAuth singleton, remove dependency
  bool get canEdit => owner == FirebaseAuth.instance.currentUser?.uid;

  /// period of the workout in weeks
  int get period => _period ?? 1;

  FredericWorkoutActivities get activities => _activities;

  @override
  void fromMap(String id, Map<String, dynamic> data) {
    this.id = id;
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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image': image,
      'owner': _owner,
      'period': period,
      'repeating': repeating,
      'startdate': Timestamp.fromDate(startDate),
      'activities': _activities.toList()
    };
  }

  void updateData(
      {String? newName,
      String? newDescription,
      String? newImage,
      int? newPeriod,
      bool? newRepeating,
      DateTime? newStartDate}) {
    _name = newName ?? name;
    _description = newDescription ?? description;
    _image = newImage ?? image;
    _period = newPeriod ?? period;
    _repeating = newRepeating ?? repeating;
    _startDate = newStartDate ?? startDate;

    if (newPeriod != null) _activities.resizeForPeriod(newPeriod);
  }

  void loadActivities(FredericActivityManager activityManager) {
    if (_activitiesList == null) return;
    final profiler = FredericProfiler.track('Workout::loadActivities');
    _activities = FredericWorkoutActivities(this);

    for (dynamic activityMap in _activitiesList!) {
      String? id = activityMap['activityid'];
      num? weekdayRaw = activityMap['weekday'];
      int weekday =
          weekdayRaw?.toInt() ?? period * 100; // to make the if fail when null

      if (weekday <= period * 7 && id != null) {
        _activities.activities[weekday].add(FredericWorkoutActivity.fromMap(
            activityManager.getActivity(id), Map.from(activityMap)));
      }
    }

    for (var list in _activities.activities) list.sort();
    profiler.stop();
  }

  ///
  /// Use this to add an activity to the workout
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
    onUpdate?.call(this);
    return true;
  }

  ///
  /// Use this to remove an activity from the workout
  ///
  void removeActivity(FredericWorkoutActivity activity, int weekday) {
    _activities.activities[weekday].remove(activity);
    _updateOrderOfActivities(weekday);
    onUpdate?.call(this);
  }

  bool swapDays(int firstWeekday, int secondWeekday) {
    firstWeekday++;
    secondWeekday++;
    bool someChanges = false;
    List<FredericWorkoutActivity> firstActivities =
        _activities.activities[firstWeekday].toList();
    _activities.activities[firstWeekday] =
        _activities.activities[secondWeekday].toList();
    _activities.activities[secondWeekday] = firstActivities;

    _activities.activities[firstWeekday].forEach((element) {
      element.changeWeekday(firstWeekday);
      someChanges = true;
    });

    _activities.activities[secondWeekday].forEach((element) {
      element.changeWeekday(secondWeekday);
      someChanges = true;
    });
    if (someChanges) onUpdate?.call(this);
    return someChanges;
  }

  void reorderActivity(int weekday, int oldIndex, int newIndex) {
    List<FredericWorkoutActivity> list = _activities.activities[weekday];

    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final activity = list.removeAt(oldIndex);
    _updateOrderOfActivities(weekday);
    list.insert(newIndex, activity);
    onUpdate?.call(this);
  }

  void _updateOrderOfActivities(int weekday) {
    List<FredericWorkoutActivity> list = _activities.activities[weekday];
    for (int i = 0; i < list.length; i++) {
      list[i].order = i;
    }
  }

  @override
  String toString() {
    return 'FredericWorkout[name: $_name, ID: $id]';
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

  int get totalNumberOfActivities {
    int totalActivities = 0;
    for (int i = 0; i <= period * 7; i++) {
      totalActivities += activities[i].length;
    }
    return totalActivities;
  }

  void resizeForPeriod(int newPeriodInWeeks) {
    while (_activities.length <= ((newPeriodInWeeks * 7))) {
      _activities.add(<FredericWorkoutActivity>[]);
    }
  }

  void trimForPeriod(int periodInWeeks) {
    while (_activities.length > (periodInWeeks * 7) + 1) {
      _activities.removeLast();
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
