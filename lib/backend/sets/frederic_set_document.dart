import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';

///
/// Represents a list of sets for a specific activity for a specific month
/// The month is calculated as the number of months starting from Jan 2021.
///   For example: August 2021 is 8, January 2022 is 13
///
class FredericSetDocument extends Comparable {
  FredericSetDocument(
      this.documentID, this.month, this.activityID, List<FredericSet> sets)
      : _sets = sets {
    _documentReference = FirebaseFirestore.instance.doc(
        'users/${FirebaseAuth.instance.currentUser?.uid}/sets/$documentID');
  }

  final String documentID;
  final int month;
  final String activityID;

  late final DocumentReference _documentReference;

  List<FredericSet> _sets;

  List<FredericSet> get sets => _sets;

  bool addSet(FredericSet set) {
    if (calculateMonth(set.timestamp) != month) return false;
    _sets.add(set);
    _writeToDatabase();
    return true;
  }

  bool deleteSet(FredericSet set) {
    if (calculateMonth(set.timestamp) != month) return false;
    _sets.remove(set);
    _writeToDatabase();
    return true;
  }

  void _writeToDatabase() {
    List<Map<String, dynamic>> setMapList = <Map<String, dynamic>>[];
    for (FredericSet set in _sets) {
      setMapList.add(set.asMap());
    }
    _documentReference.update({'sets': setMapList});
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
