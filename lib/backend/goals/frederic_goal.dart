import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';

///
/// Represents a single Goal
///
class FredericGoal implements FredericDataObject {
  ///
  /// Construct FredericGoal using a DocumentSnapshot from the database
  ///
  FredericGoal(DocumentSnapshot<Object?> snapshot) : id = snapshot.id {
    var data = (snapshot as DocumentSnapshot<Map<String, dynamic>?>).data();
    if (data == null) return;
    fromMap(snapshot.id, data);
  }

  FredericGoal.fromMap(this.id, Map<String, dynamic> data) {
    fromMap(id, data);
  }

  ///
  /// Constructs an empty Goal with an empty goalID
  ///
  FredericGoal.empty() : id = 'new';

  ///
  /// Returns an existing Goal usin the provided ID. If the Goal
  /// does not exist, an empty Goal is returned.
  ///
  factory FredericGoal.fromID(String id) {
    return FredericBackend.instance.goalManager[id] ?? FredericGoal.empty();
  }

  FredericGoal.create({
    required String title,
    required String activity,
    required String image,
    required String unit,
    required num startState,
    required num endState,
    required num currentState,
    required DateTime startDate,
    required DateTime endDate,
    required bool isComleted,
    required bool isDeleted,
  })  : id = 'new',
        _title = title,
        _activityID = activity,
        _image = image,
        _unit = unit,
        _startState = startState,
        _endState = endState,
        _currentState = currentState,
        _startDate = startDate,
        _endDate = endDate,
        _isCompleted = isComleted,
        _isDeleted = isDeleted;

  String id;

  String? _activityID;
  String? _title;
  String? _image;
  String? _unit;

  num? _startState;
  num? _endState;
  num? _currentState;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? _isCompleted;
  bool? _isDeleted;

  String get title => _title ?? 'Goal';

  String get image =>
      _image ??
      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fgoal.png?alt=media&token=9f580776-3dec-47f6-b4e2-ea8788fa02a1';

  String get activityID => _activityID ?? '';

  String get unit => _unit ?? '';

  num get startState => _startState ?? 0;

  num get endState => _endState ?? 0;

  num get currentState => _currentState ?? -1;

  DateTime get startDate => _startDate ?? DateTime.now();

  DateTime get endDate => _endDate ?? DateTime.now();

  bool get isCompleted => _isCompleted ?? false;

  bool get isNotCompleted => !isCompleted;

  bool get isDeleted => _isDeleted ?? false;

  bool get isLoss => startState > endState;

  @override
  void fromMap(String id, Map<String, dynamic> data) {
    this.id = id;
    _activityID = data['activity'];
    _title = data['title'];
    _image = data['image'];
    _unit = data['unit'];
    _startState = data['startstate'];
    _endState = data['endstate'];
    _currentState = data['currentstate'];
    _startDate = _loadDate(data['startdate']);
    _endDate = _loadDate(data['enddate']);
    _isCompleted = data['iscompleted'];
    _isDeleted = data['isdeleted'];
  }

  DateTime? _loadDate(dynamic data) {
    if (data is DateTime || data is DateTime?) return data;
    if (data is Timestamp || data is Timestamp?) return data?.toDate();
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activity': activityID,
      'title': title,
      'image': image,
      'unit': unit,
      'startstate': startState,
      'endstate': endState,
      'currentstate': currentState,
      'startdate': startDate,
      'enddate': endDate,
      'iscompleted': isCompleted,
      'isdeleted': isDeleted,
    };
  }

  void updateData({
    String? activityID,
    String? title,
    String? image,
    String? unit,
    num? startState,
    num? endState,
    num? currentState,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    bool? isDeleted,
  }) {
    _activityID = activityID ?? _activityID;
    _title = title ?? _title;
    _image = image ?? _image;
    _unit = unit ?? _unit;
    _startState = startState ?? _startState;
    _endState = endState ?? _endState;
    _currentState = currentState ?? _currentState;
    _startDate = startDate ?? _startDate;
    _endDate = endDate ?? _endDate;
    _isCompleted = isCompleted ?? _isCompleted;
    _isDeleted = isDeleted ?? _isDeleted;
  }

  @override
  String toString() {
    return 'FredericGoal[id: $id, title: $title]';
  }

  @override
  bool operator ==(Object other) {
    if (other is FredericGoal) return this.id == other.id;
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
