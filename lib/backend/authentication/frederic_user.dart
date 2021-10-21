import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/extensions.dart';
import 'package:image_picker/image_picker.dart';

///
/// Ephemeral state
/// Represents the user of the app
/// Not mutable, managed by FredericUserManager Bloc
///
class FredericUser {
  FredericUser(this._uid,
      {DocumentSnapshot<Map<String, dynamic>>? snapshot,
      this.statusMessage = '',
      this.waiting = false,
      this.registered = false}) {
    _insertDocumentSnapshot(snapshot);
    _calculateDerivedAttributes();
  }

  final bool registered;
  final String _uid;
  final String statusMessage;
  String? _email;
  String? _name;
  String? _username;
  String? _image;
  int? _weight;
  int? _height;
  int? _currentStreak;
  bool waiting;
  bool? _hasCompletedStreakToday;
  DateTime? _birthday;
  DateTime? _streakStartDate;
  DateTime? _streakLatestDate;
  List<String>? _activeWorkouts;
  List<String>? _progressMonitors;

  bool get justRegistered => registered;
  bool get authenticated => _uid != '';
  bool get finishedLoading => _name != null;
  bool get hasStreak => streak != 0;
  bool get hasCompletedStreakToday => _hasCompletedStreakToday ?? false;
  String get uid => _uid;
  String get email => _email ?? '';
  String get name => _name ?? '';
  String get username => _username ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/300x300?text=profile';
  int get weight => _weight ?? -1;
  int get height => _height ?? -1;
  int get streak => _currentStreak ?? 0;
  DateTime? get birthday => _birthday;
  DateTime? get streakStartDate => _streakStartDate;
  DateTime? get streakLatestDate => _streakLatestDate;
  List<String> get progressMonitors => _progressMonitors ?? const <String>[];
  List<String> get activeWorkouts => _activeWorkouts ?? const <String>[];

  int get age {
    if (birthday == null) return -1;
    var diff = birthday!.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  String get birthdayFormatted {
    if (_birthday == null) return 'Empty';
    return _birthday!.formattedEuropean();
  }

  set name(String value) {
    if (uid == '') return;
    if (value == name) return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': value});
    }
  }

  set username(String value) {
    if (uid == '') return;
    if (value == username) return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'username': value});
    }
  }

  set birthday(DateTime? value) {
    if (uid == '') return;
    if (value == birthday) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'birthday': value == null ? null : Timestamp.fromDate(value)});
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
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'streakstart': value == null
          ? null
          : Timestamp.fromDate(DateTime(value.year, value.month, value.day))
    });
  }

  set streakLatestDate(DateTime? value) {
    if (uid == '') return;
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'streaklatest': value == null
          ? null
          : Timestamp.fromDate(DateTime(value.year, value.month, value.day))
    });
  }

  bool streakLatestDateWasTodayOrYesterday() {
    return !streakLatestDateWasNotTodayOrYesterday();
  }

  bool streakLatestDateWasNotTodayOrYesterday() {
    var now = DateTime.now();
    return (streakLatestDate?.isNotSameDay(now) ?? true) &&
        (streakLatestDate?.isNotSameDay(now.subtract(Duration(days: 1))) ??
            true);
  }

  Future<bool> hasActivitiesOnDay(DateTime day) async {
    for (var workoutID in activeWorkouts) {
      FredericWorkout? workout =
          FredericBackend.instance.workoutManager.state.workouts[workoutID];
      if (workout == null) continue;
      if (workout.activities.getDay(day).isNotEmpty) return true;
    }
    return false;
  }

  Future<bool> updateProfilePicture(XFile imageFile) async {
    String? url = await FredericBackend.instance.storageManager
        .uploadXFileImageToUserStorage(imageFile, 'profilepicture.jpeg');
    if (url != null) {
      image = url;
      return true;
    }
    return false;
  }

  void _insertDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>>? snapshot) {
    if (snapshot?.data() == null) return;
    Map<String, dynamic>? data = snapshot!.data();

    _email = FirebaseAuth.instance.currentUser?.email ?? '';
    _name = data?['name'] ?? '';
    _username = data?['username'] ?? '';
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
  }

  void _calculateDerivedAttributes() {
    _calculateStreak();
  }

  void _calculateStreak() {
    if (_streakStartDate == null) return;
    if (streakLatestDateWasTodayOrYesterday()) {
      _currentStreak =
          _streakLatestDate!.difference(_streakStartDate!).inDays + 1;
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
