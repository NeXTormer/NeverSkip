import 'package:cloud_firestore/cloud_firestore.dart';

///
/// Contains the reps, weight and timestamp of a Set of an Activity
///
/// changing the properties also changes the values in the DB, if the values are
/// greater than zero, else nothing is changed
///
class FredericSet implements Comparable {
  FredericSet(this.setID, int reps, int weight, DateTime timestamp) {
    _reps = reps;
    _weight = weight;
    _timestamp = timestamp;
  }

  final String setID;
  int _reps;
  int _weight;
  DateTime _timestamp;

  int get reps => _reps;
  int get weight => _weight;
  DateTime get timestamp => _timestamp;

  set reps(int value) {
    if (value > 0) {
      _reps = value;
      FirebaseFirestore.instance.collection('sets').doc(setID).update({'reps': value});
    }
  }

  set weight(int value) {
    if (value >= 0) {
      _weight = value;
      FirebaseFirestore.instance.collection('sets').doc(setID).update({'weight': value});
    }
  }

  @override
  String toString() {
    return 'FredericSet[$reps reps with $weight weight on $timestamp]';
  }

  @override
  int compareTo(other) {
    if (other is FredericSet) {
      return _timestamp.compareTo(other._timestamp);
    }
    return 0;
  }
}
