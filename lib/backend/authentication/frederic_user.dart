import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/util/frederic_date_parser.dart';
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
    calculateDerivedAttributes();
  }

  FredericUser.only(this.id, String email)
      : _email = email,
        statusMessage = 'only to restore login state',
        authState = FredericAuthState.Other;

  //TODO: make final or late final
  String id;

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
  bool? _hasPurchased;
  bool? _purchaseOverride;

  bool? tempPurchaseIsPending;
  bool? tempPurchaseError;

  Map<String, DateTime?>? _activeWorkouts;
  List<String>? _progressMonitors;
  DateTime? birthday;
  DateTime? streakStartDate;
  DateTime? streakLatestDate;
  DateTime? _trialStartDate;

  bool get authenticated => authState == FredericAuthState.Authenticated;

  bool get finishedLoading => _name != null;

  bool get hasStreak => streak != 0;

  bool get hasCompletedStreakToday => _hasCompletedStreakToday ?? false;

  bool get shouldReloadFromDB => _shouldReloadData ?? false;

  bool get isDeveloper => _isDeveloper ?? false;

  bool get hasActiveTrial => getTrialDaysLeft() >= 0;

  bool get inTrialMode =>
      !hasPurchased && !(_purchaseOverride ?? false) && trialStarted;

  bool get trialStarted => _trialStartDate != null;

  bool get hasPurchased => _hasPurchased ?? false;

  bool get canUseApp => ((_hasPurchased ?? false) ||
      (_purchaseOverride ?? false) ||
      hasActiveTrial);

  String get email => _email;

  String get name => _name ?? '';

  String get username => _username ?? '';

  String get image =>
      _image ??
      'https://ui-avatars.com/api/?name=User&background=random&format=png';

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

  Map<String, DateTime?> get activeWorkouts {
    if (_activeWorkouts == null) {
      _activeWorkouts = Map<String, DateTime?>();
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
    _image = data['image'] ??
        'https://ui-avatars.com/api/?name=User&background=random&format=png';
    _weight = data['weight'];
    _height = data['height'];
    _goalsCount = data['goalscount'];
    _achievementsCount = data['achievementscount'];
    birthday = _loadDate(data['birthday']);
    _progressMonitors = data['progressmonitors']?.cast<String>() ?? <String>[];

    dynamic activeWorkoutsData = data['activeworkouts'];
    if (activeWorkoutsData is List<dynamic> ||
        activeWorkoutsData is List<String>) {
      _activeWorkouts = <String, DateTime?>{};
      for (String workout in activeWorkoutsData) {
        _activeWorkouts![workout] = null;
      }
    } else {
      if (activeWorkoutsData != null) {
        Map<String, dynamic> activeWorkoutsMap = Map.from(activeWorkoutsData);

        _activeWorkouts = activeWorkoutsMap.map(
            (key, value) => MapEntry<String, DateTime?>(key, _loadDate(value)));
      } else {
        _activeWorkouts = <String, DateTime?>{};
      }
    }

    streakStartDate = _loadDate(data['streakstart']);
    _trialStartDate = _loadDate(data['trial_start']);
    streakLatestDate = _loadDate(data['streaklatest']);

    _shouldReloadData = data['should_reload_data'];
    _isDeveloper = data['is_developer'];
    _purchaseOverride = data['free_forever_override'] ?? false;
    _hasPurchased = data['has_purchased'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': _name,
      'username': _username,
      'image': _image,
      'weight': _weight,
      'goalscount': _goalsCount,
      'achievementscount': _achievementsCount,
      'birthday':
          FredericDateParser.serialize(birthday, usePocketBase: USE_POCKETBASE),
      'progressmonitors': _progressMonitors,
      'activeworkouts': _activeWorkouts?.map((key, value) => MapEntry(
              key,
              FredericDateParser.serialize(value,
                  usePocketBase: USE_POCKETBASE))) ??
          {},
      'streakstart': FredericDateParser.serialize(streakStartDate,
          usePocketBase: USE_POCKETBASE),
      'streaklatest': FredericDateParser.serialize(streakLatestDate,
          usePocketBase: USE_POCKETBASE),
      'should_reload_data': _shouldReloadData,
      'trial_start': FredericDateParser.serialize(_trialStartDate,
          usePocketBase: USE_POCKETBASE),
      'has_purchased': _hasPurchased,
      'uid': id
    };
  }

  DateTime? _loadDate(dynamic data) {
    if (data == null) return null;
    if (data is DateTime) return data;
    // if (data is Timestamp) return data.toDate();
    if (data is String) return FredericDateParser.parse(data);
    return null;
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

  void addActiveWorkout(String workout, DateTime? startDate) {
    if (_activeWorkouts == null) _activeWorkouts = Map<String, DateTime>();
    assert(_activeWorkouts!.containsKey(workout) == false);
    _activeWorkouts![workout] = startDate;
  }

  void removeActiveWorkout(String workout) {
    if (_activeWorkouts == null) {
      _activeWorkouts = Map<String, DateTime>();
    } else {
      _activeWorkouts!.remove(workout);
    }
  }

  void onPurchased() {
    _hasPurchased = true;
  }

  void startTrial() {
    if (_trialStartDate == null) {
      _trialStartDate = DateTime.now();
    }
  }

  int getTrialDaysLeft() {
    if (_trialStartDate == null) return -1;
    DateTime trialEndDate = _trialStartDate!
        .add(Duration(days: FredericBackend.instance.defaults.trialDuration));
    return trialEndDate.difference(DateTime.now()).inDays + 1;
  }

  Future<bool> hasActivitiesOnDay(DateTime day) async {
    for (var workoutPair in activeWorkouts.entries) {
      FredericWorkout? workout = FredericBackend
          .instance.workoutManager.state.workouts[workoutPair.key];
      if (workout == null) continue;
      if (workout.activities.getDay(day, workoutPair.value).isNotEmpty)
        return true;
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

  void calculateDerivedAttributes() {
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
