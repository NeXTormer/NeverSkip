import 'package:frederic/backend/backend.dart';
import 'package:frederic/extensions.dart';
import 'package:image_picker/image_picker.dart';

class FredericUser {
  FredericUser.noAuth({this.statusMessage = ''})
      : id = '',
        authState = FredericAuthState.NotAuthenticated,
        _email = 'noauth';

  FredericUser.fromMap(this.id, String email, Map<String, dynamic> data)
      : _email = email,
        authState = FredericAuthState.Authenticated,
        statusMessage = '' {
    fromMap(id, email, data);
    _calculateDerivedAttributes();
  }

  FredericUser.only(this.id, String email)
      : _email = email,
        statusMessage = 'only to restore login state',
        authState = FredericAuthState.Other;

  //TODO: make final or late final
  String id;
  @deprecated
  String get uid => id;

  final String statusMessage;
  FredericAuthState authState;

  String _email;
  String? _name;
  String? _username;
  String? _image;
  int? _weight;
  int? _height;
  int? _currentStreak;
  int? _goalsCount;
  int? _achievementsCount;
  bool? _hasCompletedStreakToday;
  bool? _shouldReloadData;
  bool? _isDeveloper;
  List<String>? _activeWorkouts;
  List<String>? _progressMonitors;
  DateTime? birthday;
  DateTime? streakStartDate;
  DateTime? streakLatestDate;

  bool get authenticated => authState == FredericAuthState.Authenticated;
  bool get finishedLoading => _name != null;
  bool get hasStreak => streak != 0;
  bool get hasCompletedStreakToday => _hasCompletedStreakToday ?? false;
  bool get shouldReloadFromDB => _shouldReloadData ?? false;
  bool get isDeveloper => _isDeveloper ?? false;
  String get email => _email;
  String get name => _name ?? '';
  String get username => _username ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/300x300?text=profile';
  int get weight => _weight ?? -1;
  int get height => _height ?? -1;
  int get streak => _currentStreak ?? 0;
  int get goalsCount => _goalsCount ?? 0;
  int get achievementsCount => _achievementsCount ?? 0;

  List<String> get progressMonitors {
    if (_progressMonitors == null) {
      _progressMonitors = <String>[];
    }
    return _progressMonitors!;
  }

  List<String> get activeWorkouts {
    if (_activeWorkouts == null) {
      _activeWorkouts = <String>[];
    }
    return _activeWorkouts!;
  }

  int get age {
    if (birthday == null) return -1;
    var diff = birthday!.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  String get birthdayFormatted {
    if (birthday == null) return 'Empty';
    return birthday!.formattedEuropean();
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

  set name(String value) => _name = value;
  set username(String value) => _username = value;
  set goalsCount(int value) => _goalsCount = value;
  set achievementsCount(int value) => _achievementsCount = value;
  set image(String value) => _image = value;
  set shouldReloadFromDB(bool value) => _shouldReloadData = value;

  void fromMap(String id, String email, Map<String, dynamic> data) {
    this.id = id;

    _email = email;
    _name = data['name'] ?? '';
    _username = data['username'] ?? '';
    _image =
        data['image'] ?? 'https://via.placeholder.com/300x300?text=profile';
    _weight = data['weight'];
    _height = data['height'];
    _goalsCount = data['goalscount'];
    _achievementsCount = data['achievementscount'];
    birthday = data['birthday']?.toDate();
    _progressMonitors = data['progressmonitors']?.cast<String>() ?? <String>[];
    _activeWorkouts = data['activeworkouts']?.cast<String>() ?? <String>[];
    streakStartDate = data['streakstart']?.toDate();
    streakLatestDate = data['streaklatest']?.toDate();
    _shouldReloadData = data['should_reload_data'];
    _isDeveloper = data['is_developer'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': _name,
      'username': _username,
      'image': _image,
      'weight': _weight,
      'goalscount': _goalsCount,
      'achievementscount': _achievementsCount,
      'birthday': birthday,
      'progressmonitors': _progressMonitors,
      'activeworkouts': _activeWorkouts,
      'streakstart': streakStartDate,
      'streaklatest': streakLatestDate,
      'should_reload_data': _shouldReloadData,
    };
  }

  void addProgressMonitor(String monitor) {
    if (_progressMonitors == null) _progressMonitors = <String>[];
    if (!_progressMonitors!.contains(monitor)) {
      _progressMonitors!.add(monitor);
    }
  }

  void removeProgressMonitor(String monitor) {
    if (_progressMonitors == null) {
      _progressMonitors = <String>[];
    } else {
      _progressMonitors!.remove(monitor);
    }
  }

  void addActiveWorkout(String workout) {
    if (_activeWorkouts == null) _activeWorkouts = <String>[];
    if (!_activeWorkouts!.contains(workout)) {
      _activeWorkouts!.add(workout);
    }
  }

  void removeActiveWorkout(String workout) {
    if (_activeWorkouts == null) {
      _activeWorkouts = <String>[];
    } else {
      _activeWorkouts!.remove(workout);
    }
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

  void _calculateDerivedAttributes() {
    _calculateStreak();
  }

  void _calculateStreak() {
    if (streakStartDate == null) return;
    if (streakLatestDateWasTodayOrYesterday()) {
      _currentStreak =
          streakLatestDate!.difference(streakStartDate!).inDays + 1;
    }
  }

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  String toString() {
    return 'FredericUser[$id, $name]';
  }

  @override
  int get hashCode => super.hashCode;
}

enum FredericAuthState { Authenticated, NotAuthenticated, Other }
