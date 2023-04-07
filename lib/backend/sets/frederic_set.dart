import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';

/// Contains the reps, weight and timestamp of a Set of an Activity
///
/// Immutable, cant be changed. Can only be deleted using the FredericSetDocument
/// class.
///
/// !*IMPORTANT*!: The ID property of this class is unused
///
class FredericSet implements Comparable, FredericDataObject {
  FredericSet(this.reps, this.weight, this.timestamp);

  FredericSet.fromMap(Map<String, dynamic> map)
      : reps = map['reps'],
        weight = map['value']?.toDouble(),
        timestamp = map['timestamp']?.toDate();

  int reps;
  double weight;
  DateTime timestamp;

  int get monthID {
    int yearDiff = timestamp.year - FredericSetManager.startingYear;
    return timestamp.month + (yearDiff * 12);
  }

  bool operator ==(other) {
    if (other is FredericSet)
      return timestamp.isAtSameMomentAs(other.timestamp);
    return false;
  }

  @override
  String toString() {
    return 'FredericSet[$reps reps with $weight weight on $timestamp]';
  }

  @override
  int compareTo(other) {
    return other.timestamp.compareTo(timestamp);
  }

  @override
  int get hashCode => Object.hash(reps, weight, timestamp);

  @override
  void fromMap(String id, Map<String, dynamic> data) {
    reps = data['reps'];
    weight = data['value']?.toDouble();
    timestamp = data['timestamp']?.toDate();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'value': weight,
      'timestamp': Timestamp.fromDate(timestamp)
    };
  }

  @override
  String get id => "not-implemented";
}
