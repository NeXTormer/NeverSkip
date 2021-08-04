import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/extensions.dart';

///
/// Represents the user of the app
/// Not mutable, managed by FredericUserManager Bloc
///
class FredericUser {
  FredericUser(this._uid,
      {DocumentSnapshot<Map<String, dynamic>>? snapshot,
      this.statusMessage = '',
      this.waiting = false,
      this.shouldUpdateStreak = false}) {
    insertDocumentSnapshot(snapshot);
  }

  final String _uid;
  final String statusMessage;
  String? _email;
  String? _name;
  String? _image;
  int? _weight;
  int? _height;
  int _currentStreak = 0;
  bool waiting;
  bool shouldUpdateStreak;
  bool? _hasStreak;
  bool? _hasCompletedStreakToday;
  DateTime? _birthday;
  DateTime? _streakStartDate;
  DateTime? _streakLatestDate;
  List<String>? _activeWorkouts;
  List<String>? _progressMonitors;

  bool get authenticated => _uid != '';
  bool get finishedLoading => _name != null;
  bool get hasStreak => _hasStreak ?? false;
  bool get hasCompletedStreakToday => _hasCompletedStreakToday ?? false;
  String get uid => _uid;
  String get email => _email ?? '';
  String get name => _name ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/300x300?text=profile';
  int get weight => _weight ?? -1;
  int get height => _height ?? -1;
  int get currentStreak => _currentStreak;
  DateTime get birthday => _birthday ?? DateTime.now();
  DateTime? get streakStartDate => _streakStartDate;
  DateTime? get streakLatestDate => _streakLatestDate;
  List<String> get progressMonitors => _progressMonitors ?? const <String>[];
  List<String> get activeWorkouts => _activeWorkouts ?? const <String>[];

  int get age {
    var diff = birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  set name(String value) {
    if (uid == '') return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': value});
    }
  }

  set progressMonitors(List<String> value) {
    if (uid == '') return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'progressmonitors': value});
  }

  set activeWorkouts(List<String> value) {
    if (uid == '') return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'activeworkouts': value});
  }

  set image(String value) {
    if (uid == '') return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'image': value});
    }
  }

  set streakStartDate(DateTime? value) {
    if (uid == '') return;
    FirebaseFirestore.instance.collection('users').doc(uid).update(
        {'streakstart': value == null ? null : Timestamp.fromDate(value)});
  }

  set streakLatestDate(DateTime? value) {
    if (uid == '') return;
    FirebaseFirestore.instance.collection('users').doc(uid).update(
        {'streaklatest': value == null ? null : Timestamp.fromDate(value)});
  }

  void insertDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>>? snapshot) {
    if (snapshot?.data() == null) return;
    Map<String, dynamic>? data = snapshot!.data();

    _email = FirebaseAuth.instance.currentUser?.email ?? '';
    _name = data?['name'] ?? '';
    _image =
        data?['image'] ?? 'https://via.placeholder.com/300x300?text=profile';
    _weight = data?['weight'];
    _height = data?['height'];
    _birthday = data?['birthday']?.toDate();
    _progressMonitors =
        data?['progressmonitors']?.cast<String>() ?? const <String>[];
    _activeWorkouts =
        data?['activeworkouts']?.cast<String>() ?? const <String>[];
    _streakStartDate = data?['streakstart']?.toDate();
    _streakLatestDate = data?['streaklatest']?.toDate();

    if (_streakLatestDate != null) {
      if (_streakStartDate == null) {
        streakStartDate = _streakLatestDate;
      }
    }

    if (shouldUpdateStreak) {
      _updateStreak();
    }
    if (_streakStartDate?.isSameDay(_streakLatestDate) ?? false) {
      _currentStreak = 1;
    }
  }

  /// Called once when the user logs in (i.e. every app start)
  void _updateStreak() async {
    if (_checkIfStreakNeedsUpdating()) {
      var lastCompletion = _streakLatestDate;
      var now = DateTime.now();
      bool streakBroken = false;
      for (int i = 0;
          now.subtract(Duration(days: i)).isNotSameDay(lastCompletion);
          i++) {
        bool calendarDayIsEmpty =
            await hasActivitiesOnDay(now.subtract(Duration(days: i)));
        if (!calendarDayIsEmpty) {
          streakBroken = true;
          break;
        }
      }
      if (streakBroken) {
        streakStartDate = null;
        streakLatestDate = null;
        _currentStreak = 0;
      } else {
        streakLatestDate = DateTime.now();
        _currentStreak =
            _streakStartDate!.difference(_streakLatestDate!).inDays;
      }
    }
  }

  Future<bool> hasActivitiesOnDay(DateTime day) async {
    await FredericBackend.instance.workoutManager.waitForFirstReload();
    for (var workoutID in activeWorkouts) {
      FredericWorkout? workout =
          FredericBackend.instance.workoutManager.workouts[workoutID];
      if (workout == null) continue;
      if (workout.activities.getDay(day).isNotEmpty) return true;
    }
    return false;
  }

  /// when this returns true, both _streakStartDate and _streakLatestDate are
  /// not null
  bool _checkIfStreakNeedsUpdating() {
    if (_streakStartDate == null) {
      return false;
    }
    if (_streakLatestDate != null) {
      if (_streakLatestDate!.isSameDay(DateTime.now())) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other);
  }

  @override
  String toString() {
    return 'FredericUser[$uid, $name, waiting: $waiting, authenticated: $authenticated]';
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
