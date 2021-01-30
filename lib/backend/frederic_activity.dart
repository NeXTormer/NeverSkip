import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_set.dart';

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
  FredericActivity(this.activityID);

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
  List<FredericSet> _sets;
  StreamController<FredericActivity> _streamController;

  String get name => _name ?? 'emptyname';
  String get description => _description ?? 'emptydescription';
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
    stderr.writeln(
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
      _loadSetsOnce();
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
    } else {
      await _loadSetsOnce();
      return this;
    }
  }

  //============================================================================
  /// Used to populate the data from outside using literal data
  /// Currently only for futures
  ///
  void insertData(String name, String description, String image, String owner,
      int recommendedSets, int recommendedReps) {
    _isFuture = true;
    _name = name;
    _description = description;
    _image = image;
    _owner = owner;
    _recommendedReps = recommendedReps;
    _recommendedSets = recommendedSets;
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
  /// loads or updates the sets
  ///
  Future<void> _loadSetsOnce() async {
    String userid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference activitiyProgressCollection =
        FirebaseFirestore.instance.collection('sets');
    QuerySnapshot progressSnapshot = await activitiyProgressCollection
        .where('owner', isEqualTo: userid)
        .where('activity', isEqualTo: activityID)
        .orderBy('timestamp', descending: true)
        .get();
    _processSetQuerySnapshot(progressSnapshot);
    return;
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
  /// Copies one activity (can be global, from another user, or from logged in user) to
  /// the users activities
  ///
  static Future<FredericActivity> copyActivity(FredericActivity activity) {
    return newActivity(activity.name, activity.description, activity.image,
        activity.recommendedSets, activity.recommendedReps);
  }

  //============================================================================
  /// Creates a new activity using the passed [name], [description], and [image] in the
  /// DB and returns it as a future when finished.
  /// The [owner] is the current user
  ///
  static Future<FredericActivity> newActivity(String name, String description,
      String image, int recommendedSets, int recommendedReps) async {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');
    DocumentReference newActivity = await activities.add({
      'name': name,
      'description': description,
      'image': image,
      'recommendedsets': recommendedSets,
      'recommendedreps': recommendedReps,
      'owner': FirebaseAuth.instance.currentUser.uid
    });

    FredericActivity a = new FredericActivity(newActivity.id);
    a.insertData(
        name,
        description,
        image,
        FirebaseAuth.instance.currentUser.uid,
        recommendedSets,
        recommendedReps);
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
}
