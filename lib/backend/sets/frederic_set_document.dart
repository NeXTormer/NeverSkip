import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';

///
/// Represents a list of sets for a specific activity for a specific month
/// The month is calculated as the number of months starting from Jan 2021.
///   For example: August 2021 is 8, January 2022 is 13
///
class FredericSetDocument implements Comparable, FredericDataObject {
  FredericSetDocument(this.id, List<FredericSet> sets) : sets = sets;

  FredericSetDocument.fromMap(this.id, Map<String, dynamic> data) {
    fromMap(id, data);
  }

  @deprecated
  String get documentID => id;

  String get activityID => _activityID;

  int get month => _month;

  final String id;

  int _month = 0;
  String _activityID = '';

  List<FredericSet> sets = <FredericSet>[];

  @override
  void fromMap(String id, Map<String, dynamic> data) {
    _activityID = data['activityid'] ?? '';
    _month = data['month'] ?? 0;

    List<dynamic> setList = data['sets'] ?? [];

    for (final set in setList) {
      sets.add(FredericSet.fromMap(Map.from(set)));
    }
  }

  @override
  Map<String, dynamic> toMap() {
    assert(_activityID != '', 'ActivityID can\'t be empty');
    List<Map<String, dynamic>> setMapList = <Map<String, dynamic>>[];
    for (FredericSet set in sets) {
      setMapList.add(set.toMap());
    }
    return <String, dynamic>{
      'activityid': _activityID,
      'month': _month,
      'sets': setMapList
    };
  }

  static int calculateMonth(DateTime timestamp) {
    int yearDiff = timestamp.year - FredericSetManager.startingYear;
    return timestamp.month + (yearDiff * 12);
  }

  @override
  int compareTo(other) {
    if (other is FredericSetDocument)
      return other.month - month;
    else
      return 0;
  }
}
