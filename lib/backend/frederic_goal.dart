import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';

///
/// A Goal and a achievement are the same object. Achieved goals are
/// automatically achievements. Additionally not completed goals can also be
/// added to the achievements
///
/// Currently only supports Stream loading
///
/// As always, changing the properties of this class also updates the DB values
///
class FredericGoal {
  FredericGoal(String uid, FredericGoalManager goalManager) {
    goalID = uid;
    _goalManager = goalManager;
    _documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('goals')
        .doc(uid);
    _activityManager = FredericBackend.instance().activityManager;
  }

  String goalID;
  String _activityID;

  FredericActivity _activity;

  FredericGoalManager _goalManager;
  FredericActivityManager _activityManager;

  DocumentReference _documentReference;

  String _title;
  String _image;

  num _start;
  num _end;
  num _current;
  Timestamp _startDate;
  Timestamp _endDate;
  bool _isCompleted;
  bool _isDeleted;

  String get uid => goalID;
  String get title => _title ?? 'Goal';
  String get image => _image ?? 'https://via.placeholder.com/500x400?text=Goal';
  String get activityID => _activityID;
  num get startState => _start ?? 0;
  num get endState => _end ?? 0;
  num get currentState => _current ?? -1;
  DateTime get startDate => _startDate.toDate() ?? DateTime.now();
  DateTime get endDate => _endDate.toDate() ?? DateTime.now();
  bool get isCompleted => _isCompleted ?? false;
  bool get isNotCompleted => !isCompleted;
  bool get isDeleted => _isDeleted ?? false;
  bool get isLoss => startState > endState;
  FredericActivity get activity => _activity;

  double get progress {
    double diff = endState.toDouble() - startState.toDouble();
    double change = currentState.toDouble() - startState.toDouble();
    double percentage = change / diff;
    if (percentage < 0) percentage = 0;
    if (percentage > 1) percentage = 1;
    print('progress $percentage');
    return percentage;
  }

  int get progressPercentage {
    num diff = endState - startState;
    num change = currentState - startState;
    num percentage = change / diff;
    if (percentage < 0) percentage = 0;
    if (percentage > 1) percentage = 1;
    return (percentage * 100).toInt();
  }

  String get timeLeftFormatted {
    int days = endDate.difference(DateTime.now()).inDays;
    return '$days';
    if (days > 7) {
      return '${days ~/ 7} week${(days ~/ 7) != 1 ? 's' : ''}';
    }
    return '$days day${days != 1 ? 's' : ''}';
  }

  set title(String value) {
    if (value.isNotEmpty) {
      _documentReference.update({'title': value});
    }
  }

  set image(String value) {
    if (value.isNotEmpty) {
      _documentReference.update({'title': value});
    }
  }

  set startState(num value) {
    if (value >= 0) {
      _documentReference.update({'startstate': value});
    }
  }

  set endState(num value) {
    if (value >= 0) {
      _documentReference.update({'endstate': value});
    }
  }

  set endDate(DateTime value) {
    if (value.isAfter(startDate)) {
      _documentReference.update({'enddate': value});
    }
  }

  void updateData() {
    if (_activity == null) {
      _activity = _activityManager[activityID];
      _activity?.addListener(updateData);
    }
    _current = _activity?.bestProgress;
    _goalManager.updateData();
  }

  void insertData(DocumentSnapshot snapshot) {
    _activityID = snapshot.data()['activity'];
    _title = snapshot.data()['title'];
    _image = snapshot.data()['image'];
    _start = snapshot.data()['startstate'];
    _end = snapshot.data()['endstate'];
    _startDate = snapshot.data()['startdate'];
    _endDate = snapshot.data()['enddate'];
    _isCompleted = snapshot.data()['iscompleted'];

    if (_activity == null) {
      _activityManager.addListener(updateData);
      _activity = _activityManager[activityID];
      _activity?.addListener(updateData);
    }

    updateData();
  }

  bool operator ==(other) => goalID == other.goalID;

  void discard() {
    _activity?.removeListener(updateData);
    _activityManager?.removeListener(updateData);
  }

  @override
  int get hashCode => goalID.hashCode;
}

enum FredericGoalType { Weight, Reps }
