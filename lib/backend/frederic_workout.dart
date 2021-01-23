import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/frederic_activity.dart';

///
/// Contains all the data for a workout
///
/// A list of activities can either be accessed by [activities.<weekday>] or by
/// [activities.activities[<weekday_id>]
///
/// All setters perform basic value checks, e.g. if an empty string is passed in,
/// it is ignored
///
class FredericWorkout {
  FredericWorkout(this.workoutID);

  final workoutID;
  FredericWorkoutActivities _activities;
  String _name;
  String _description;
  String _image;
  String _owner;
  String _ownerName;

  String get name => _name;
  String get description => _description;
  String get image => _image;
  String get owner => _owner;
  String get ownerName => _ownerName;

  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('workouts').doc(workoutID).update({'name': value});
      _name = value;
    }
  }

  set description(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('workouts').doc(workoutID).update({'description': value});
      _description = value;
    }
  }

  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('workouts').doc(workoutID).update({'image': value});
      _image = value;
    }
  }

  ///
  /// Loads data from the DB corresponding to the [workoutID]
  /// returns a future string when done
  ///
  Future<String> loadData() async {
    if (this.workoutID == null) return 'no-workout-id';

    DocumentReference workoutsDocument = FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    DocumentSnapshot documentSnapshot = await workoutsDocument.get();
    _name = documentSnapshot['name'];
    _description = documentSnapshot['description'];
    _image = documentSnapshot['image'];
    _owner = documentSnapshot['owner'];
    _ownerName = documentSnapshot['ownerName'];

    QuerySnapshot activitiesSnapshot = await workoutsDocument.collection('activities').get();

    _activities = FredericWorkoutActivities();

    for (int i = 0; i < activitiesSnapshot.docs.length; i++) {
      int weekday = activitiesSnapshot.docs[i]['weekday'];
      if (weekday > 8) return 'wrong-weekday-in-db-($weekday)';
      FredericActivity a = FredericActivity(activitiesSnapshot.docs[i]['activity']);
      a.weekday = weekday;
      _activities.activities[weekday].add(a);
      await a.loadData();
    }

    return 'success';
  }

  ///
  /// Adds an activity to the workout on the specified weekday
  /// Use this to add an activity instead of using activities.add() because
  /// this also adds it to the DB
  ///
  String addActivity(FredericActivity activity, Weekday day) {
    List<FredericActivity> list = _activities.activities[day.index];
    if (list.contains(activity)) {
      return 'activity-already-in-list';
    }
    if (_activities.everyday.contains(activity)) {
      return 'activity-already-in-everyday-list';
    }
    list.add(activity);

    _addActivityDB(activity, day);
    return 'success';
  }

  ///
  /// Removes an activity from the workout on the specified weekday
  /// Use this to remove an activity instead of using activities.remove() because
  /// this also removes it on the DB
  ///
  void removeActivity(FredericActivity activity, Weekday day) {
    List<FredericActivity> list = _activities.activities[day.index];
    list.remove(activity);
    _removeActivityDB(activity, day);
  }

  ///
  /// Moves the activity to another day in the workout plan
  ///
  void moveActivityToOtherDay(FredericActivity activity, Weekday to) async {
    int fromWeekday = activity.weekday;
    int toWeekday = to.index;

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID).collection('activities');

    QuerySnapshot snapshot = await collectionReference
        .where('activity', isEqualTo: activity.activityID)
        .where('weekday', isEqualTo: fromWeekday)
        .get();

    if (snapshot.docs.length != 1) return;

    String docID = snapshot.docs[0].id;
    collectionReference.doc(docID).update({'weekday': toWeekday});
  }

  void _addActivityDB(FredericActivity activity, Weekday day) {
    DocumentReference workoutReference = FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    workoutReference.collection('activities').add({'activity': activity.activityID, 'weekday': day.index});
  }

  Future<void> _removeActivityDB(FredericActivity activity, Weekday day) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID).collection('activities');

    QuerySnapshot snapshot = await collectionReference
        .where('activity', isEqualTo: activity.activityID)
        .where('weekday', isEqualTo: day.index)
        .get();

    if (snapshot.docs.length != 1) return;

    String docID = snapshot.docs[0].id;
    collectionReference.doc(docID).delete();
  }

  @override
  String toString() {
    String s =
        'FredericWorkout[name: $_name, description: $_description, ID: $workoutID, image: $_image, owner: $_owner, ownerName: $_ownerName]';
    for (int i = 0; i < 8; i++) {
      if (_activities.activities[i].isNotEmpty) {
        s += '\n╚> ${Weekday.values[i]}\n';
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
    for (int i = 0; i < 8; i++) {
      activities[i] = List<FredericActivity>();
    }
  }

  List<List<FredericActivity>> activities = List<List<FredericActivity>>(8);

  List<FredericActivity> get everyday => activities[0];
  List<FredericActivity> get monday => activities[1];
  List<FredericActivity> get tuesday => activities[2];
  List<FredericActivity> get wednesday => activities[3];
  List<FredericActivity> get thursday => activities[4];
  List<FredericActivity> get friday => activities[5];
  List<FredericActivity> get saturday => activities[6];
  List<FredericActivity> get sunday => activities[7];

  ///
  /// the count of all activities in this workout
  ///
  int get count {
    return monday.length +
        tuesday.length +
        wednesday.length +
        thursday.length +
        friday.length +
        saturday.length +
        sunday.length +
        everyday.length;
  }
}

enum Weekday { Everyday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }
