import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  DateTime get birthday => _birthday ?? DateTime.now();
  DateTime? get streakStartDate => _streakStartDate;
  DateTime? get streakLatestDate => _streakLatestDate;
  List<String> get progressMonitors => _progressMonitors ?? const <String>[];
  List<String> get activeWorkouts => _activeWorkouts ?? const <String>[];

  int get age {
    var diff = birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
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

    if (shouldUpdateStreak) {
      _updateStreak();
    }
  }

  void _updateStreak() {
    if (_checkIfStreakNeedsUpdating()) {
      
      //check if there have been no activities in the calendar from startdate to now
    }
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
