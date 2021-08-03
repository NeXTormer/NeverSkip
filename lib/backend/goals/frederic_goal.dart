import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';

///
/// Represents a single Goal
///
class FredericGoal {
  ///
  /// Construct FredericGoal usin a DocumentSnapshot from the database
  ///
  FredericGoal(DocumentSnapshot<Object?> snapshot) : goalID = snapshot.id {
    var data = (snapshot as DocumentSnapshot<Map<String, dynamic>?>).data();
    if (data == null) return;

    _title = data['title'];
    _image = data['image'];
    _start = data['start'];
    _end = data['end'];
    _current = data['current'];
    _startDate = data['startDate'];
    _endDate = data['endDate'];
    _isCompleted = data['isCompleted'];
    _isDeleted = data['isDeleted'];
  }

  ///
  /// Constructs an empty Goal with an empty goalID
  ///
  FredericGoal.empty() : goalID = '';

  ///
  /// Returns an existing Goal usin the provided ID. If the Goal
  /// does not exist, an empty Goal is returned.
  ///
  factory FredericGoal.fromID(String id) {
    return FredericBackend.instance.goalManager[id] ?? FredericGoal.empty();
  }

  FredericGoal.create({
    required String title,
    required String image,
    required num start,
    required num end,
    required num current,
    required Timestamp startDate,
    required Timestamp endDate,
    required bool isComleted,
    required bool isDeleted,
  })   : goalID = 'new-goal',
        _title = title,
        _image = image,
        _start = start,
        _end = end,
        _current = current,
        _startDate = startDate,
        _endDate = endDate,
        _isCompleted = isComleted,
        _isDeleted = isDeleted;

  final String goalID;
  late String _activityID;

  String? _title;
  String? _image;

  num? _start;
  num? _end;
  num? _current;
  Timestamp? _startDate;
  Timestamp? _endDate;
  bool? _isCompleted;
  bool? _isDeleted;

  String get title => _title ?? 'Goal';
  String get image => _image ?? 'https://via.placeholder.com/400x400?text=Goal';
  String get activityID => _activityID;
  num get startState => _start ?? 0;
  num get endState => _end ?? 0;
  num get currentState => _current ?? -1;
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
          .collection('goals')
          .doc(goalID)
          .update({'title': value});
      _title = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the image url of the goal in the Database
  ///
  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'image': value});
      _image = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the start state of the goal in the Database
  ///
  set startState(num value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'start': value});
      _start = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the end state of the goal in the Database
  ///
  set endState(num value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'end': value});
      _end = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the current state of the goal in the Database
  ///
  set currentState(num value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'current': value});
      _current = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the start date of the goal in the Database
  ///
  set startDate(DateTime value) {
    if (true) {
      // TODO sinnvoller check
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'startDate': value});
      _startDate = Timestamp.fromDate(value);
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the end date of the goal in the Database
  ///
  set endDate(DateTime value) {
    if (value.isAfter(startDate)) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'endDate': value});
      _endDate = Timestamp.fromDate(value);
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the isCompleted boolean of the goal in the Database
  ///
  set isCompleted(bool value) {
    if (value != _isCompleted) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'isCompleted': value});
      _isCompleted = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
  }

  ///
  /// Updates the isDeleted boolean of the goal in the Database
  ///
  set isDeleted(bool value) {
    if (value != _isDeleted) {
      FirebaseFirestore.instance
          .collection('goals')
          .doc(goalID)
          .update({'isDeleted': value});
      _isDeleted = value;
      FredericBackend.instance.goalManager.add(FredericGoalUpdateEvent(this));
    }
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
