import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';

///
/// Represents a single Goal
///
class FredericGoal {
  ///
  /// Construct FredericGoal usin a DocumentSnapshot from the database
  ///
  FredericGoal(DocumentSnapshot<Object?> snapshot, this._goalManager)
      : goalID = snapshot.id {
    var data = (snapshot as DocumentSnapshot<Map<String, dynamic>?>).data();
    if (data == null) return;
    _activityID = data['activity'];
    _title = data['title'];
    _image = data['image'];
    _startState = data['startstate'];
    _endState = data['endstate'];
    _currentState = data['currentstate'];
    _startDate = data['startdate'];
    _endDate = data['enddate'];
    _isCompleted = data['iscompleted'];
    _isDeleted = data['isdeleted'];
  }

  ///
  /// Constructs an empty Goal with an empty goalID
  ///
  FredericGoal.empty(this._goalManager) : goalID = 'new';

  ///
  /// Returns an existing Goal usin the provided ID. If the Goal
  /// does not exist, an empty Goal is returned.
  ///
  factory FredericGoal.fromID(String id) {
    return FredericBackend.instance.goalManager[id] ??
        FredericGoal.empty(FredericBackend.instance.goalManager);
  }

  FredericGoal.create({
    required String title,
    required String activity,
    required String image,
    required num startState,
    required num endState,
    required num currentState,
    required Timestamp startDate,
    required Timestamp endDate,
    required bool isComleted,
    required bool isDeleted,
  })   : goalID = 'new',
        _title = title,
        _activityID = activity,
        _image = image,
        _startState = startState,
        _endState = endState,
        _currentState = currentState,
        _startDate = startDate,
        _endDate = endDate,
        _isCompleted = isComleted,
        _isDeleted = isDeleted,
        _goalManager = FredericBackend.instance.goalManager;

  final FredericGoalManager _goalManager;
  final String goalID;
  String? _activityID;

  String? _title;
  String? _image;

  num? _startState;
  num? _endState;
  num? _currentState;
  Timestamp? _startDate;
  Timestamp? _endDate;
  bool? _isCompleted;
  bool? _isDeleted;

  String get title => _title ?? 'Goal';
  String get image => _image ?? 'https://via.placeholder.com/400x400?text=Goal';
  String get activityID => _activityID ?? '';
  num get startState => _startState ?? 0;
  num get endState => _endState ?? 0;
  num get currentState => _currentState ?? -1;
  DateTime get startDate => _startDate?.toDate() ?? DateTime.now();
  DateTime get endDate => _endDate?.toDate() ?? DateTime.now();
  bool get isCompleted => _isCompleted ?? false;
  bool get isNotCompleted => !isCompleted;
  bool get isDeleted => _isDeleted ?? false;
  bool get isLoss => startState > endState;

  ///
  /// Updates the title of the goal in the Database
  ///
  set title(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'title': value});
      _title = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  set activityID(String value) {
    if (value != '') {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'activity': value});
      _activityID = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the image url of the goal in the Database
  ///
  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'image': value});
      _image = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the start state of the goal in the Database
  ///
  set startState(num value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'startstate': value});
      _startState = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the end state of the goal in the Database
  ///
  set endState(num value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'endstate': value});
      _endState = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the current state of the goal in the Database
  ///
  set currentState(num value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'currentstate': value});
      _currentState = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the start date of the goal in the Database
  ///
  set startDate(DateTime value) {
    if (true) {
      // TODO sinnvoller check
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'startDate': value});
      _startDate = Timestamp.fromDate(value);
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the end date of the goal in the Database
  ///
  set endDate(DateTime value) {
    if (true) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'endDate': value});
      _endDate = Timestamp.fromDate(value);
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the isCompleted boolean of the goal in the Database
  ///
  set isCompleted(bool value) {
    if (value != _isCompleted) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'iscompleted': value});
      _isCompleted = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  ///
  /// Updates the isDeleted boolean of the goal in the Database
  ///
  set isDeleted(bool value) {
    if (value != _isDeleted) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals')
          .doc(goalID)
          .update({'isdeleted': value});
      _isDeleted = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(goalID));
    }
  }

  void save({
    required String activityID,
    required String title,
    required String image,
    required num startState,
    required num endState,
    required num currentState,
    required Timestamp startDate,
    required Timestamp endDate,
    required bool isComleted,
    required bool isDeleted,
  }) async {
    if (goalID != 'new') return;
    CollectionReference goals = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('goals');
    var newGoal = await goals.add({
      'activity': activityID,
      'title': title,
      'image': image,
      'startstate': startState,
      'endstate': endState,
      'currentstate': currentState,
      'startdate': startDate,
      'enddate': endDate,
      'iscompleted': isCompleted,
      'isdeleted': isDeleted,
    });
    var snapshot = await newGoal.get();
    _goalManager
        .add(FredericGoalCreateEvent(FredericGoal(snapshot, _goalManager)));
  }

  void delete() {
    _goalManager.add(FredericGoalDeleteEvent(this));
  }

  @override
  String toString() {
    return 'FredericGoal[id: $goalID, title: $title]';
  }

  @override
  bool operator ==(Object other) {
    if (other is FredericGoal) return this.goalID == other.goalID;
    return false;
  }

  @override
  int get hashCode => goalID.hashCode;
}
