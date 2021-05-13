import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:frederic/backend/backend.dart';
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
class FredericActivity with ChangeNotifier {
  FredericActivity(this.activityID) {
    _muscleGroups = <FredericActivityMuscleGroup>[];
    _setsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('sets');

    loadSets();
  }

  final String activityID;

  String? _name;
  String? _description;
  String? _image;
  String? _owner;
  int? _recommendedSets;
  int? _recommendedReps;
  late int _weekday;
  int? _order;
  bool _areSetsLoaded = false;

  /// true if some sets have been loaded from the DB,
  /// meaning the latest sets are definitely loaded
  bool _latestSetsLoaded = false;
  FredericActivityType? _type;
  List<FredericSet>? _sets;
  List<FredericActivityMuscleGroup>? _muscleGroups;
  late CollectionReference _setsCollection;

  String get name => _name ?? 'Empty activity';
  String get description => _description ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/400x400?text=noimage';
  String get owner => _owner ?? 'No owner';
  int get recommendedReps => _recommendedReps ?? 1;
  int get recommendedSets => _recommendedSets ?? 1;
  int get weekday => _weekday;
  bool get areSetsLoaded => _areSetsLoaded;
  bool get isNull => _name == null;
  bool get latestSetsLoaded => _latestSetsLoaded;

  List<FredericSet>? get sets {
    if (_sets == null) {
      _sets = <FredericSet>[];
    }
    return _sets;
  }

  bool get hasProgress {
    if (_sets == null) return false;
    if (_sets!.isEmpty) return false;
    return true;
  }

  bool get isGlobalActivity {
    return _owner == 'global';
  }

  int get bestWeight {
    int max = 0;
    sets!.forEach((element) {
      if (element.weight > max) max = element.weight;
    });
    return max;
  }

  int get bestReps {
    int max = 0;
    sets?.forEach((element) {
      max = element.reps > max ? element.reps : max;
    });
    return max;
  }

  int? get averageReps {
    if (!hasProgress) return _recommendedReps;
    int sum = 0;
    sets!.forEach((element) {
      sum += element.reps;
    });
    return sum ~/ _sets!.length;
  }

  int get bestProgress {
    if (_type == FredericActivityType.Calisthenics) {
      return bestReps;
    } else
      return bestWeight;
  }

  String get bestProgressType {
    if (_type == FredericActivityType.Weighted) return 'kg';
    if (_type == FredericActivityType.Calisthenics) return 'reps';
    if (_type == FredericActivityType.Stretch) return 's';
    return '';
  }

  List<FredericActivityMuscleGroup>? get muscleGroups => _muscleGroups;

  FredericActivityType? get type => _type;

  ///
  /// Also updates the name on the Database
  ///
  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'name': value});
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
      if (_muscleGroups!.contains(parameters[i])) return true;
    }
    return false;
  }

  //============================================================================
  /// returns true if the activity matches the provided Filter Controller
  ///
  bool matchFilterController(ActivityFilterController controller) {
    bool match = false;
    if (!controller.types![_type!]!) return false;
    for (var value in controller.muscleGroups!.entries) {
      if (value.value!) {
        if (_muscleGroups!.contains(value.key)) match = true;
      }
    }
    if (match) {
      if (controller.searchText == '') {
        return true;
      } else {
        if (_name!
            .toLowerCase()
            .contains(controller.searchText!.toLowerCase())) {
          return true;
        } else
          return false;
      }
    }
    return false;
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
      FredericActivityType? type) {
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
  FredericActivity insertSnapshot(DocumentSnapshot snapshot) {
    _processDocumentSnapshot(
        snapshot as DocumentSnapshot<Map<String, dynamic>>);
    return this;
  }

  //============================================================================
  /// Used add sets to the Activity using a QuerySnapshot. If a set is a duplicate,
  /// it is not added twice.
  ///
  void insertSetQuerySnapshot(QuerySnapshot snapshot) {
    _processSetQuerySnapshot(snapshot as QuerySnapshot<Map<String, dynamic>>);
  }

  //============================================================================
  /// Loads the last [limit] sets. By default the [limit] is 5
  ///
  /// Loads the sets once. if a set is added or removed it is done on the db as
  /// well as on the local storage
  ///
  Future<FredericActivity> loadSets([int limit = 5]) async {
    if (limit > 5) _latestSetsLoaded = true;
    QuerySnapshot snapshot = await _setsCollection
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    _processSetQuerySnapshot(snapshot as QuerySnapshot<Map<String, dynamic>>);
    return this;
  }

  //============================================================================
  /// Reads the QuerySnapshot from the activityprogress and fills the FredericSet
  /// list
  ///
  void _processSetQuerySnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (_sets == null) _sets = <FredericSet>[];

    for (int i = 0; i < snapshot.docs.length; i++) {
      var element = snapshot.docs[i];
      Timestamp ts = element.data()['timestamp'];
      FredericSet set = FredericSet(element.id, element.data()['reps'],
          element.data()['weight'], ts.toDate());

      if (_sets!.contains(set)) {
        _sets!.remove(set);
      }
      _sets!.add(set);
    }
    notifyListeners();
  }

  //============================================================================
  ///
  /// Reads the DocumentSnapshot and inserts its values in the activity properties
  ///
  void _processDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _name = snapshot.data()!['name'];
    _description = snapshot.data()!['description'];
    _image = snapshot.data()!['image'];
    _owner = snapshot.data()!['owner'];
    _order = snapshot.data()!['order'];
    _recommendedReps = snapshot.data()!['recommendedreps'];
    _recommendedSets = snapshot.data()!['recommendedsets'];
    _type = parseType(snapshot.data()!['type']);

    List<dynamic> musclegroups = snapshot.data()!['musclegroup'];
    _muscleGroups!.clear();
    musclegroups.forEach((element) {
      if (element is String)
        _muscleGroups!.add(parseSingleMuscleGroup(element));
    });
    notifyListeners();
  }

  //============================================================================
  /// Adds the [reps] and [weight] passed to a new set, with the current time
  /// as the [timestamp]
  /// The set is added to the list in this Activity and to the DB
  ///
  /// First adds a temporary set to the set list in case the user is offline and
  /// the 'add' call is never completed. If the 'add' call is completed, the
  /// temporary set is removed and the real set added.
  ///
  void addProgress(int reps, int weight) async {
    String tempID = Random().nextInt(100000).toString();
    FredericSet set = FredericSet(tempID, reps, weight, DateTime.now(), true);
    _sets!.add(set);
    notifyListeners();
    DocumentReference docRef = await _setsCollection.add({
      'reps': reps,
      'weight': weight,
      'timestamp': Timestamp.now(),
      'activity': activityID
    });
    _sets!.remove(set);
    _sets!.add(FredericSet(docRef.id, reps, weight, DateTime.now()));
    notifyListeners();
  }

  //============================================================================
  /// Removes the passed [fset] from the list in this Activity and from the DB
  ///
  void removeProgress(FredericSet fset) {
    _sets!.remove(fset);
    _setsCollection.doc(fset.setID).delete();
    notifyListeners();
  }

  //============================================================================
  /// Parses the type String from the DB to the [FredericActivityType] object.
  /// The String can be:
  ///   - weighted
  ///   - cali
  ///   - stretch
  ///
  static FredericActivityType parseType(String? typeString) {
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
    List<FredericActivityMuscleGroup> l = <FredericActivityMuscleGroup>[];
    for (int i = 0; i < muscleGroupsStrings.length; i++) {
      l.add(parseSingleMuscleGroup(muscleGroupsStrings[i]));
    }
    return l;
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
    List<String> strings = <String>[];
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
    return create(
        activity.name,
        activity.description,
        activity.image,
        activity.recommendedSets,
        activity.recommendedReps,
        activity.muscleGroups!,
        activity.type);
  }

  //============================================================================
  /// Creates a new activity using the passed [name], [description], and [image] in the
  /// DB and returns it as a future when finished.
  /// The [owner] is the current user
  ///
  static Future<FredericActivity> create(
      String name,
      String description,
      String image,
      int recommendedSets,
      int recommendedReps,
      List<FredericActivityMuscleGroup> muscleGroups,
      FredericActivityType? type) async {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');
    DocumentReference newActivity = await activities.add({
      'name': name,
      'description': description,
      'image': image,
      'recommendedsets': recommendedSets,
      'recommendedreps': recommendedReps,
      'owner': FirebaseAuth.instance.currentUser!.uid,
      'musclegroup': parseMuscleGroupListToStringList(muscleGroups)
    });

    FredericActivity a = new FredericActivity(newActivity.id);
    a.insertData(
        name,
        description,
        image,
        FirebaseAuth.instance.currentUser!.uid,
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

  @override
  String toString() {
    String s =
        'FredericActivity[id: $activityID, name: $name, description: $description, weekday: $_weekday, order: $_order, owner: $owner]';
    if (!hasProgress) return s;

    for (int i = 0; i < _sets!.length; i++) {
      s += '\n ╚=> ${_sets![i].toString()}';
    }
    return s;
  }

  @override
  int get hashCode => activityID.hashCode;
}

enum FredericActivityType { Weighted, Calisthenics, Stretch }

enum FredericActivityMuscleGroup { Arms, Chest, Back, Abs, Legs, None }
