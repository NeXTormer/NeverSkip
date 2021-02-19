import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_controller.dart';

///
/// Contains all the data for an Activity ([name], [description], [image], [owner]), the
/// [sets] the user has done (if there are any), and the [weekday] and [order] of the
/// activity in a workout (if it is in a workout).
///
/// Calling the constructor does not load any data, use [loadData()] or [asStream()] to
/// load the data.
///
/// Activities with the same ID but with different weekdays can exist.
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
  FredericActivity(this.activityID) {
    _muscleGroups = List<FredericActivityMuscleGroup>();
  }

  final String activityID;

  String _name;
  String _description;
  String _image;
  String _owner;
  int _recommendedSets;
  int _recommendedReps;
  int _weekday;
  int _order;
  bool _areSetsLoaded = false;
  bool _isStream = false;
  bool _setStreamExists = false;
  bool _isFuture = false;
  FredericActivityType _type;
  List<FredericSet> _sets;
  List<FredericActivityMuscleGroup> _muscleGroups;
  StreamController<FredericActivity> _streamController;

  String get name => _name ?? 'Empty activity';
  String get description => _description ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/400x400?text=noimage';
  String get owner => _owner ?? 'emptyowner';
  int get recommendedReps => _recommendedReps;
  int get recommendedSets => _recommendedSets;
  int get weekday => _weekday;
  bool get isStream => _isStream;
  bool get isNotStream => !_isStream;
  bool get areSetsLoaded => _areSetsLoaded;
  bool get isNull => _name == null;

  List<FredericSet> get sets {
    if (_areSetsLoaded || _sets != null) {
      return _sets;
    }
    print(
        '[FredericActivity] Error: tried accessing sets when they are not loaded');
    return null;
  }

  bool get isSingleActivity {
    return _weekday == null ? true : false;
  }

  bool get hasProgress {
    if (_sets == null) return false;
    if (_sets.isEmpty) return false;
    return true;
  }

  bool get isGlobalActivity {
    return _owner == 'global';
  }

  int get bestWeight {
    if (hasProgress) {
      int max = 0;
      _sets.forEach((element) {
        if (element.weight > max) max = element.weight;
      });
      return max;
    }
    return 0;
  }

  List<FredericActivityMuscleGroup> get muscleGroups => _muscleGroups;

  FredericActivityType get type => _type;

  ///
  /// Also updates the name on the Database
  ///
  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'name': value});
      if (_isFuture) _name = value;
    }
  }

  ///
  /// Also updates the description on the Database
  ///
  set description(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'description': value});
      if (_isFuture) _description = value;
    }
  }

  ///
  /// Also updates the image on the Database
  ///
  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'image': value});
      if (_isFuture) _image = value;
    }
  }

  ///
  /// Also updates the recommended reps on the Database
  ///
  set recommendedReps(int value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'recommendedreps': value});
      if (_isFuture) _recommendedReps = value;
    }
  }

  ///
  /// Also updates the recommended sets on the Database
  ///
  set recommendedSets(int value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'recommendedsets': value});
      if (_isFuture) _recommendedSets = value;
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

  //============================================================================
  /// returns true if the activity matches the provided muscle group
  ///
  bool filterMuscle(List<FredericActivityMuscleGroup> parameters) {
    for (int i = 0; i < parameters.length; i++) {
      if (_muscleGroups.contains(parameters[i])) return true;
    }
    return false;
  }

  //============================================================================
  /// returns true if the activity matches the provided Filter Controller
  ///
  bool matchFilterController(ActivityFilterController controller) {
    bool match = false;
    if (!controller.types[_type]) return false;
    for (var value in controller.muscleGroups.entries) {
      if (value.value) {
        if (_muscleGroups.contains(value.key)) match = true;
      }
    }
    if (match) {
      if (controller.searchText == '') {
        return true;
      } else {
        if (_name.toLowerCase().contains(controller.searchText.toLowerCase())) {
          return true;
        } else
          return false;
      }
    }
    return false;
  }

  //============================================================================
  /// Loads data from the DB corresponding to the [activityID]
  /// returns a future when done
  /// Optional parameter [loadSets] is false by default
  /// If [loadSets] is set to true, the user progress on this activity
  /// is loaded as well
  ///
  /// Either use this or [asStream()], not both
  ///
  Future<FredericActivity> loadData([bool loadSets = false]) async {
    if (activityID == null) return null;
    if (_isStream) return null;
    _isFuture = true;
    _sets = List<FredericSet>();

    DocumentReference activityDocument =
        FirebaseFirestore.instance.collection('activities').doc(activityID);

    DocumentSnapshot snapshot = await activityDocument.get();
    _processDocumentSnapshot(snapshot);

    if (loadSets) {
      loadSetsOnce();
      _areSetsLoaded = true;
    }

    return this;
  }

  //============================================================================
  /// Returns a stream of [FredericActivity], which supports real time updates
  ///
  /// Either use this or [loadData()], but not both
  ///
  /// If [loadSets] is set to true, the user progress on this activity
  /// is loaded as well
  ///
  Stream<FredericActivity> asStream([loadSets = false]) {
    if (_isFuture) return null;
    if (activityID == null) return null;
    _isStream = true;
    _sets = List<FredericSet>();
    _streamController = StreamController<FredericActivity>();

    Stream<DocumentSnapshot> documentStream = FirebaseFirestore.instance
        .collection('activities')
        .doc(activityID)
        .snapshots();
    documentStream.listen(_processDocumentSnapshot);

    if (loadSets) {
      _loadSetsStream();
      _areSetsLoaded = true;
    }

    return _streamController.stream;
  }

  //============================================================================
  /// Use this method to either:
  ///   - Load or update the sets if using normal loading
  ///   - Load the sets and add them to the Stream if using stream loading
  ///
  /// only really async when not using streams
  ///
  Future<FredericActivity> loadSets() async {
    if (_isStream) {
      _loadSetsStream();
      return null;
    } else {
      await loadSetsOnce();
      return this;
    }
  }

  //============================================================================
  /// Used to populate the data from outside using literal data
  /// Currently only for futures, does not update the database
  ///
  void insertData(
      String name,
      String description,
      String image,
      String owner,
      int recommendedSets,
      int recommendedReps,
      List<FredericActivityMuscleGroup> muscleGroups,
      FredericActivityType type) {
    _isFuture = true;
    _name = name;
    _description = description;
    _image = image;
    _owner = owner;
    _recommendedReps = recommendedReps;
    _recommendedSets = recommendedSets;
    _muscleGroups = muscleGroups;
    _type = type;
  }

  //============================================================================
  /// Used to populate the data from outside using a documentsnapshot
  /// Currently only for futures
  ///
  void insertSnapshot(DocumentSnapshot snapshot) {
    _isFuture = true;
    _isStream = false;
    _processDocumentSnapshot(snapshot);
  }

  //============================================================================
  /// Used by FredericBackend when bulk loading a lot of activities using an
  /// outside stream
  ///
  void loadSetsUsingOutsideStream(StreamController<FredericActivity> stream) {
    if (!_isStream) {
      stderr.writeln('[FredericActivity] Error: is not a stream');
      return;
    }
    if (_setStreamExists) {
      stderr.writeln('[FredericActivity] Error: Set Stream already exists');
      return;
    }
    _setStreamExists = true;
    String userid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference activitiyProgressCollection =
        FirebaseFirestore.instance.collection('sets');

    Stream<QuerySnapshot> setStream = activitiyProgressCollection
        .where('owner', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .snapshots();

    setStream.listen((event) {
      _processSetQuerySnapshot(event);
      stream.add(this);
    });
  }

  //============================================================================
  /// Loads the sets and adds it to the stream if it has not been added yet
  ///
  void _loadSetsStream() {
    if (_setStreamExists) return;
    _setStreamExists = true;
    String userid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference activitiyProgressCollection =
        FirebaseFirestore.instance.collection('sets');

    Stream<QuerySnapshot> setStream = activitiyProgressCollection
        .where('owner', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .snapshots();
    setStream.listen(_processSetQuerySnapshot);
  }

  //============================================================================
  /// Loads the sets in a self-contained stream, whether it is a stream or a future
  ///
  StreamController<FredericActivity> loadSetsStreamOnce([int limit = 5]) {
    String userid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference activitiyProgressCollection =
        FirebaseFirestore.instance.collection('sets');

    StreamController<FredericActivity> controller =
        StreamController<FredericActivity>();

    Stream<QuerySnapshot> setStream = activitiyProgressCollection
        .where('owner', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
    setStream.listen((snapshot) {
      _processSetQuerySnapshot(snapshot);
      controller.add(this);
    });
    return controller;
  }

  //============================================================================
  /// loads or updates the sets
  ///
  Future<FredericActivity> loadSetsOnce([int limit = 5]) async {
    String userid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference activitiyProgressCollection =
        FirebaseFirestore.instance.collection('sets');
    QuerySnapshot progressSnapshot = await activitiyProgressCollection
        .where('owner', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    _processSetQuerySnapshot(progressSnapshot);
    return this;
  }

  //============================================================================
  /// Reads the QuerySnapshot from the activityprogress and fills the FredericSet
  /// list
  ///
  void _processSetQuerySnapshot(QuerySnapshot snapshot) {
    if (_sets == null) _sets = List<FredericSet>();
    _sets.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      var map = snapshot.docs[i];
      Timestamp ts = map.data()['timestamp'];

      _sets.add(FredericSet(
          map.id, map.data()['reps'], map.data()['weight'], ts.toDate()));
    }
    if (_isStream && _name != null) _streamController.add(this);
  }

  //============================================================================
  ///
  /// Reads the DocumentSnapshot and inserts its values in the activity properties
  ///
  void _processDocumentSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()['name'];
    _description = snapshot.data()['description'];
    _image = snapshot.data()['image'];
    _owner = snapshot.data()['owner'];
    _order = snapshot.data()['order'];
    _recommendedReps = snapshot.data()['recommendedreps'];
    _recommendedSets = snapshot.data()['recommendedsets'];
    _type = parseType(snapshot.data()['type']);

    List<dynamic> musclegroups = snapshot.data()['musclegroup'];
    _muscleGroups.clear();
    musclegroups.forEach((element) {
      if (element is String) _muscleGroups.add(parseSingleMuscleGroup(element));
    });

    if (_isStream && _name != null) _streamController?.add(this);
  }

  //============================================================================
  /// Adds the [reps] and [weight] passed to a new set, with the current time
  /// as the [timestamp]
  /// The set is added to the list in this Activity and to the DB
  ///
  void addProgress(int reps, int weight) async {
    CollectionReference setsCollection =
        FirebaseFirestore.instance.collection('sets');

    DocumentReference docRef = await setsCollection.add({
      'reps': reps,
      'weight': weight,
      'owner': FirebaseAuth.instance.currentUser.uid,
      'timestamp': Timestamp.now(),
      'activity': activityID
    });
    _sets.add(FredericSet(docRef.id, reps, weight, DateTime.now()));
  }

  //============================================================================
  /// Removes the passed [fset] from the list in this Activity and from the DB
  ///
  void removeProgress(FredericSet fset) {
    _sets.remove(fset);
    FirebaseFirestore.instance.collection('sets').doc(fset.setID).delete();
  }

  //============================================================================
  /// Calculates the maximum value (either weight for weighted activities, or
  /// number of reps for calisthenics activities) in the loaded sets.
  /// If no sets are loaded, the returned value is 0.
  ///
  num getCurrentBestProgress() {
    num max = 0;
    if (_type == FredericActivityType.Weighted) {
      sets.forEach((element) {
        max = element.weight > max ? element.weight : max;
      });
    } else if (_type == FredericActivityType.Calisthenics) {
      sets.forEach((element) {
        max = element.reps > max ? element.reps : max;
      });
    }
    return max;
  }

  //============================================================================
  /// Parses the type String from the DB to the [FredericActivityType] object.
  /// The String can be:
  ///   - weighted
  ///   - cali
  ///   - stretch
  ///
  static FredericActivityType parseType(String typeString) {
    if (typeString == null) return FredericActivityType.Weighted;
    if (typeString == 'weighted') return FredericActivityType.Weighted;
    if (typeString == 'cali') return FredericActivityType.Calisthenics;
    if (typeString == 'stretch') return FredericActivityType.Stretch;
    return FredericActivityType.Weighted;
  }

  //============================================================================
  /// Parses a muscle groups list from the DB to the [List<FredericActivityMuscleGroup>] object.
  /// The String can be:
  ///   - arms
  ///   - chest
  ///   - back
  ///   - legs
  ///   - abs
  ///   - '' or none
  ///
  static List<FredericActivityMuscleGroup> parseMuscleGroups(
      List<String> muscleGroupsStrings) {
    List<FredericActivityMuscleGroup> l = List<FredericActivityMuscleGroup>();
    for (int i = 0; i < muscleGroupsStrings.length; i++) {
      l.add(parseSingleMuscleGroup(muscleGroupsStrings[i]));
    }
  }

  //============================================================================
  /// Parses the muscle groups from the DB to the [FredericActivityMuscleGroup] object.
  /// The String can be:
  ///   - arms
  ///   - chest
  ///   - back
  ///   - legs
  ///   - abs
  ///   - '' or none
  ///
  static FredericActivityMuscleGroup parseSingleMuscleGroup(
      String muscleGroup) {
    switch (muscleGroup) {
      case 'arms':
        return FredericActivityMuscleGroup.Arms;
      case 'chest':
        return FredericActivityMuscleGroup.Chest;
      case 'back':
        return FredericActivityMuscleGroup.Back;
      case 'legs':
        return FredericActivityMuscleGroup.Legs;
      case 'abs':
        return FredericActivityMuscleGroup.Abs;
      default:
        return FredericActivityMuscleGroup.None;
    }
  }

  //============================================================================
  /// Parses the [FredericActivityMuscleGroup] back to a string for the DB
  ///
  static String parseSingleMuscleGroupToString(
      FredericActivityMuscleGroup group) {
    switch (group) {
      case FredericActivityMuscleGroup.Arms:
        return 'arms';
      case FredericActivityMuscleGroup.Chest:
        return 'chest';
      case FredericActivityMuscleGroup.Back:
        return 'back';
      case FredericActivityMuscleGroup.Legs:
        return 'legs';
      case FredericActivityMuscleGroup.Abs:
        return 'abs';
      default:
        return 'none';
    }
  }

  //============================================================================
  /// Parses a [List<FredericActivityMuscleGroup>] back to a [List<String>] for
  /// the DB
  ///
  static List<String> parseMuscleGroupListToStringList(
      List<FredericActivityMuscleGroup> groupList) {
    List<String> strings = List<String>();
    for (int i = 0; i < groupList.length; i++) {
      strings.add(parseSingleMuscleGroupToString(groupList[i]));
    }
    return strings;
  }

  //============================================================================
  /// Copies one activity (can be global, from another user, or from logged in user) to
  /// the users activities
  ///
  static Future<FredericActivity> copyActivity(FredericActivity activity) {
    return newActivity(
        activity.name,
        activity.description,
        activity.image,
        activity.recommendedSets,
        activity.recommendedReps,
        activity.muscleGroups,
        activity.type);
  }

  //============================================================================
  /// Creates a new activity using the passed [name], [description], and [image] in the
  /// DB and returns it as a future when finished.
  /// The [owner] is the current user
  ///
  static Future<FredericActivity> newActivity(
      String name,
      String description,
      String image,
      int recommendedSets,
      int recommendedReps,
      List<FredericActivityMuscleGroup> muscleGroups,
      FredericActivityType type) async {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');
    DocumentReference newActivity = await activities.add({
      'name': name,
      'description': description,
      'image': image,
      'recommendedsets': recommendedSets,
      'recommendedreps': recommendedReps,
      'owner': FirebaseAuth.instance.currentUser.uid,
      'musclegroup': parseMuscleGroupListToStringList(muscleGroups)
    });

    FredericActivity a = new FredericActivity(newActivity.id);
    a.insertData(
        name,
        description,
        image,
        FirebaseAuth.instance.currentUser.uid,
        recommendedSets,
        recommendedReps,
        muscleGroups,
        type);
    return a;
  }

  @override
  bool operator ==(Object other) {
    if (other is FredericActivity) return this.activityID == other.activityID;
    return false;
  }

  void dispose() {
    _streamController.close();
  }

  @override
  String toString() {
    String s =
        'FredericActivity[id: $activityID, name: $name, description: $description, weekday: $_weekday, order: $_order, owner: $owner]';
    if (!hasProgress) return s;

    for (int i = 0; i < _sets.length; i++) {
      s += '\n ╚=> ${_sets[i].toString()}';
    }
    return s;
  }

  @override
  int get hashCode => activityID.hashCode;
}

enum FredericActivityType { Weighted, Calisthenics, Stretch }

enum FredericActivityMuscleGroup { Arms, Chest, Back, Abs, Legs, None }
