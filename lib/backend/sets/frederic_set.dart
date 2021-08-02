import 'package:cloud_firestore/cloud_firestore.dart';
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
        weight = map['value'] {
    Timestamp ts = map['timestamp'];
    timestamp = ts.toDate();
  }

  final int reps;
  final int weight;
  late final DateTime timestamp;

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
    return other.timestamp.compareTo(timestamp);
  }

  @override
  int get hashCode => hashValues(reps, weight, timestamp);
}
