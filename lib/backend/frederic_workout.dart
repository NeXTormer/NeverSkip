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

  Future<void> loadData() async {
    if (this.workoutID == null) return;

    DocumentReference workoutsDocument =
        FirebaseFirestore.instance.collection('workouts').doc(workoutID);

    DocumentSnapshot documentSnapshot = await workoutsDocument.get();
    name = documentSnapshot['name'];
    description = documentSnapshot['description'];
    image = documentSnapshot['image'];
    owner = documentSnapshot['owner'];
    ownerName = documentSnapshot['ownerName'];

    List<Map<String, dynamic>> wa = documentSnapshot['activities'];

    for (int i = 0; i < 8; i++) {
      activities.activities[i] = List<FredericActivity>();
    }

    wa.forEach((element) {
      activities.activities[element['weekday']].add(element['activity']);
    });
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

    _addActivityToDB(activity, day);
    return 'success';
  }

  void removeActivity(FredericActivity activity, Weekday day) {
    List<FredericActivity> list = activities.activities[day.index];
    list.remove(activity);
    _removeActivityFromDB(activity, day);
  }

  Future<void> _addActivityToDB(FredericActivity activity, Weekday day) async {}
  Future<void> _removeActivityFromDB(
      FredericActivity activity, Weekday day) async {}

  @override
  String toString() {
    String s =
        'FredericWorkout[name: $name, description: $description, ID: $workoutID, image: $image, owner: $owner, ownerName: $ownerName]';
    for (int i = 0; i < 8; i++) {
      s += '\n--> ${Weekday.values[i]}\n';
      activities.activities[i].forEach((element) {
        s += element.toString() + '\n';
      });
    }

    return s;
  }
}

class FredericWorkoutActivities {
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
