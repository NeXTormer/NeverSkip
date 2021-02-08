import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_set.dart';

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
  FredericGoal(String uid) {
    _uid = uid;
    _documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('goals')
        .doc(uid);
    sets = List<FredericSet>();
  }

  String _uid;
  String _activityID;

  DocumentReference _documentReference;
  List<FredericSet> sets;

  String _title;
  String _image;
  String _type;

  num _start;
  num _end;
  num _current;
  Timestamp _startDate;
  Timestamp _endDate;
  bool _isCompleted;
  bool _isDeleted;

  String get uid => _uid;
  String get title => _title ?? 'Goal';
  String get image => _image ?? 'https://via.placeholder.com/500x400?text=Goal';
  String get activityID => _activityID;
  String get type => _type;
  num get startState => _start ?? 0;
  num get endState => _end ?? 0;
  num get currentState => _current ?? -69;
  DateTime get startDate => _startDate.toDate() ?? DateTime.now();
  DateTime get endDate => _endDate.toDate() ?? DateTime.now();
  bool get isCompleted => _isCompleted ?? false;
  bool get isNotCompleted => !_isCompleted;
  bool get isDeleted => _isDeleted ?? false;
  bool get isLoss => startState > endState;

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
    if (days > 7) {
      return '${days ~/ 7} weeks';
    }
    return '$days days';
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

  set type(String value) {
    if (value.isNotEmpty) {
      _documentReference.update({'type': value});
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

  void insertData(DocumentSnapshot snapshot) {
    _activityID = snapshot.data()['activity'];
    _title = snapshot.data()['title'];
    _image = snapshot.data()['image'];
    _start = snapshot.data()['startstate'];
    _end = snapshot.data()['endstate'];
    _startDate = snapshot.data()['startdate'];
    _endDate = snapshot.data()['enddate'];
    _isCompleted = snapshot.data()['iscompleted'];
    _type = snapshot.data()['type'];
  }

  void calculateCurrentProgress() {
    num max = 0;
    if (_type == 'weight') {
      sets.forEach((element) {
        max = element.weight > max ? element.weight : max;
      });
    } else if (_type == 'reps') {
      sets.forEach((element) {
        max = element.reps > max ? element.reps : max;
      });
    }
    _current = max;
  }
}

enum FredericGoalType { Weight, Reps }
