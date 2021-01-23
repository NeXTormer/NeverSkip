import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_set.dart';

///
/// Contains all the data for an Activity ([name], [description], [image], [owner]), the
/// [sets] the user has done (if there are any), and the [weekday] and [order] of the
/// activity in a workout (if it is in a workout).
///
/// Calling the constructor does not load any data, use [loadData()] to load the data.
///
/// Activities with the same [ID], but a different [weekday] can exist
///
/// The Weekday is stored as an int, with Monday being 1, Tuesday being 2, ...
/// 0 means everyday
///
/// Changing a property of this class also changes it on the Database
///
/// All actions performed on an FredericActivity are relative to the current logged in
/// user
///
/// If the activity is not part of a workout, the [isSingleActivity] property is true.
///
/// If there is progress from the user the [hasProgress] property is true.
///
/// All setters perform basic value checks, e.g. if an empty string is passed in,
/// it is ignored
///
class FredericActivity {
  FredericActivity(this.activityID);

  final String activityID;

  String _name;
  String _description;
  String _image;
  String _owner;
  int _weekday;
  int _order;
  List<FredericSet> _sets;

  String get name => _name;
  String get description => _description;
  String get image => _image;
  String get owner => _owner;
  int get weekday => _weekday;
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

  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('activities').doc(activityID).update({'name': value});
      _name = value;
    }
  }

  set description(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('activities').doc(activityID).update({'description': value});
      _description = value;
    }
  }

  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('activities').doc(activityID).update({'image': value});
      _image = value;
    }
  }

  ///
  /// Does not update DB
  ///
  set weekday(int value) {
    if (value >= 0 && value <= 7) {
      _weekday = value;
    }
  }

  ///
  /// Loads data from the DB corresponding to the [activityID]
  /// returns a future when done
  ///
  Future<void> loadData() async {
    if (activityID == null) return false;

    DocumentReference activityDocument = FirebaseFirestore.instance.collection('activities').doc(activityID);

    DocumentSnapshot snapshot = await activityDocument.get();

    _name = snapshot.data()['name'];
    _description = snapshot.data()['description'];
    _image = snapshot.data()['image'];
    _owner = snapshot.data()['owner'];

    String userid = FirebaseAuth.instance.currentUser.uid;

    CollectionReference activitiyProgressCollection = FirebaseFirestore.instance.collection('sets');

    QuerySnapshot progressSnapshot = await activitiyProgressCollection
        .where('owner', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .get();

    if (progressSnapshot.docs.length == 0) {
      return;
    }
    _sets = List<FredericSet>();

    for (int i = 0; i < progressSnapshot.docs.length; i++) {
      var map = progressSnapshot.docs[i];
      Timestamp ts = map['timestamp'];

      _sets.add(FredericSet(map.id, map['reps'], map['weight'], ts.toDate()));
    }
  }

  ///
  /// Adds the [reps] and [weight] passed to a new set, with the current time
  /// as the [timestamp]
  /// The set is added to the list in this Activity and to the DB
  ///
  void addProgress(int reps, int weight) async {
    CollectionReference setsCollection = FirebaseFirestore.instance.collection('sets');

    DocumentReference docRef = await setsCollection.add({
      'reps': reps,
      'weight': weight,
      'owner': FirebaseAuth.instance.currentUser.uid,
      'timestamp': Timestamp.now(),
      'activity': activityID
    });
    _sets.add(FredericSet(docRef.id, reps, weight, DateTime.now()));
  }

  ///
  /// Removes the passed [fset] from the list in this Activity and from the DB
  ///
  void removeProgress(FredericSet fset) {
    _sets.remove(fset);
    FirebaseFirestore.instance.collection('sets').doc(fset.setID).delete();
  }

  ///
  /// Copies one activity (can be global, from another user, or from logged in user) to
  /// the users activities
  ///
  static Future<FredericActivity> copyActivity(FredericActivity activity) {
    return newActivity(activity.name, activity.description, activity.image);
  }

  ///
  /// Creates a new activity using the passed [name], [description], and [image] in the
  /// DB and returns it as a future when finished.
  /// The [owner] is the current user
  ///
  static Future<FredericActivity> newActivity(String name, String description, String image) async {
    CollectionReference activities = FirebaseFirestore.instance.collection('activities');
    DocumentReference newActivity = await activities.add(
        {'name': name, 'description': description, 'image': image, 'owner': FirebaseAuth.instance.currentUser.uid});

    FredericActivity a = new FredericActivity(newActivity.id);
    a._description = description;
    a._name = name;
    a._image = image;
    a._owner = FirebaseAuth.instance.currentUser.uid;
    return a;
  }

  @override
  bool operator ==(Object other) {
    if (other is FredericActivity) return this.activityID == other.activityID;
    return false;
  }

  @override
  String toString() {
    String s =
        'FredericActivity[name: $name, description: $description, weekday: $_weekday, order: $_order, owner: $owner]';
    if (!hasProgress) return s;

    for (int i = 0; i < _sets.length; i++) {
      s += '\n ╚=> ${_sets[i].toString()}';
    }
    return s;
  }
}
