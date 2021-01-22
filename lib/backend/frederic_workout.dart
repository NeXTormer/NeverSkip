import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/frederic_activity.dart';

class FredericWorkout {
  FredericWorkout(this.workoutID);

  FredericWorkoutActivities activities;
  String workoutID;
  String name;
  String description;
  String image;
  String owner;
  String ownerName;

  Future<String> loadData() async {
    if (this.workoutID == null) return 'no-workout-id';

    DocumentReference workoutsDocument =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    DocumentSnapshot documentSnapshot = await workoutsDocument.get();
    name = documentSnapshot['name'];
    description = documentSnapshot['description'];
    image = documentSnapshot['image'];
    owner = documentSnapshot['owner'];
    ownerName = documentSnapshot['ownerName'];

    QuerySnapshot activitiesSnapshot =
        await workoutsDocument.collection('activities').get();

    activities = FredericWorkoutActivities();

    for (int i = 0; i < activitiesSnapshot.docs.length; i++) {
      int weekday = activitiesSnapshot.docs[i]['weekday'];
      if (weekday > 8) return 'wrong-weekday-in-db-($weekday)';
      FredericActivity a =
          FredericActivity(activitiesSnapshot.docs[i]['activity']);
      activities.activities[weekday].add(a);
      await a.loadData();
    }

    return 'success';
  }

  void insertDataBulk() {}

  String addActivity(FredericActivity activity, Weekday day) {
    List<FredericActivity> list = activities.activities[day.index];
    if (list.contains(activity)) {
      return 'activity-already-in-list';
    }
    if (activities.everyday.contains(activity)) {
      return 'activity-already-in-everyday-list';
    }
    list.add(activity);

    _addActivityDB(activity, day);
    return 'success';
  }

  void removeActivity(FredericActivity activity, Weekday day) {
    List<FredericActivity> list = activities.activities[day.index];
    list.remove(activity);
    _removeActivityDB(activity, day);
  }

  void moveActivityToOtherDay(FredericActivity activity, Weekday to) async {
    int fromWeekday = activity.weekday;
    int toWeekday = to.index;

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
    collectionReference.doc(docID).update({'weekday': toWeekday});
  }

  void _addActivityDB(FredericActivity activity, Weekday day) {
    DocumentReference workoutReference =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    workoutReference
        .collection('activities')
        .add({'activity': activity.activityID, 'weekday': day.index});
  }

  Future<void> _removeActivityDB(FredericActivity activity, Weekday day) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('workouts')
        .doc(workoutID)
        .collection('activities');

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
        'FredericWorkout[name: $name, description: $description, ID: $workoutID, image: $image, owner: $owner, ownerName: $ownerName]';
    for (int i = 0; i < 8; i++) {
      if (activities.activities[i].isNotEmpty) {
        s += '\n╚> ${Weekday.values[i]}\n';
      }
      activities.activities[i].forEach((element) {
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

  // ===========================================================================
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

enum Weekday {
  Everyday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday
}
