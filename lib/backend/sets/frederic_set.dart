import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';

///
/// Contains the reps, weight and timestamp of a Set of an Activity
///
/// Immutable, cant be changed. Can only be deleted using the FredericSetDocument
/// class.
///
class FredericSet implements Comparable {
  FredericSet(this.reps, this.weight, this.timestamp);

  FredericSet.fromMap(Map<String, dynamic> map)
      : reps = map['reps'],
        weight = map['value'],
        timestamp = map['timestamp'];

  final int reps;
  final int weight;
  final DateTime timestamp;

  int get month {
    int yearDiff = timestamp.year - FredericSetManager.startingYear;
    return timestamp.month + (yearDiff * 12);
  }

  Map<String, dynamic> asMap() {
    return {'reps': reps, 'value': weight, 'timestamp': timestamp};
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
    if (other is FredericSet) {
      return timestamp.compareTo(other.timestamp);
    }
    return 0;
  }

  @override
  int get hashCode => hashValues(reps, weight, timestamp);
}
