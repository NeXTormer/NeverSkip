import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';

///
/// A Goal and a achievement are the same object. Achieved goals are
/// automatically achievements. Additionally not completed goals can also be
/// added to the achievements
///
/// As always, changing the properties of this class also updates the DB values
///
class FredericGoal {
  FredericGoal(this.goalID) {
    _documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('goals')
        .doc(uid);
  }

  final String goalID;
  late String _activityID;

  FredericActivity? activity;

  late final DocumentReference _documentReference;

  String? _title;
  String? _image;

  num? _start;
  num? _end;
  num? _current;
  Timestamp? _startDate;
  Timestamp? _endDate;
  bool? _isCompleted;
  bool? _isDeleted;

  String get uid => goalID;
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

  double get progress {
    _current = activity?.bestProgress ?? -1;
    double diff = endState.toDouble() - startState.toDouble();
    double change = currentState.toDouble() - startState.toDouble();
    double percentage = change / diff;
    if (percentage < 0) percentage = 0;
    if (percentage > 1) percentage = 1;
    return percentage;
  }

  int get progressPercentage {
    _current = activity?.bestProgress ?? -1;
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
  }

  set currentState(num value) {
    _current = value;
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

  void insertData(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _activityID = snapshot.data()?['activity'] ?? '';
    if (_activityID == '') return;
    _title = snapshot.data()?['title'];
    _image = snapshot.data()?['image'];
    _start = snapshot.data()?['startstate'];
    _end = snapshot.data()?['endstate'];
    _startDate = snapshot.data()?['startdate'];
    _endDate = snapshot.data()?['enddate'];
    _isCompleted = snapshot.data()?['iscompleted'];

    activity = FredericBackend.instance.activityManager?[activityID];
  }

  bool operator ==(other) {
    if (other is FredericGoal) return goalID == other.goalID;
    return false;
  }

  @override
  int get hashCode => goalID.hashCode;
}

enum FredericGoalType { Weight, Reps }
