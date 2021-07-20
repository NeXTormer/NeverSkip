import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';

///
/// Represents all loaded sets of a specific activity. Use this class to add
/// and remove single sets.
///
class FredericSetList {
  FredericSetList(this.activityID, FredericSetManager setManager)
      : _setManager = setManager {
    loadData(2);
  }

  final String activityID;
  final FredericSetManager _setManager;

  int _bestWeight = 0;
  int _bestReps = 0;

  List<FredericSetDocument> _setDocuments = <FredericSetDocument>[];

  int get bestWeight => _bestWeight;
  int get bestReps => _bestReps;

  List<FredericSet> getLatestSets([int count = 6]) {
    List<FredericSet> sets = <FredericSet>[];
    _setDocuments.sort();
    int documentIndex = 0;
    int setIndex = -1;
    for (int i = 0; i < count; i++) {
      setIndex++;
      if (documentIndex >= _setDocuments.length) break;
      if (setIndex >= _setDocuments[documentIndex].sets.length) {
        documentIndex++;
        setIndex = -1;
        continue;
      }
      _setDocuments[documentIndex].sets.sort();
      sets.add(_setDocuments[documentIndex].sets[setIndex]);
    }
    return sets;
  }

  void _calculateBestProgress() {
    for (FredericSetDocument setDoc in _setDocuments) {
      for (FredericSet set in setDoc.sets) {
        if (set.reps > _bestReps) _bestReps = set.reps;
        if (set.weight > _bestWeight) _bestWeight = set.weight;
      }
    }
  }

  void deleteSet(FredericSet set) {
    if (_setDocuments
        .where((element) => element.month == set.month)
        .first
        .deleteSet(set)) {
      if (set.weight >= _bestWeight) {
        _calculateBestProgress();
      }
      if (set.reps >= _bestReps) {
        _calculateBestProgress();
      }
      _setManager.add(FredericSetEvent(<String>[activityID]));
    }
  }

  void addSet(FredericSet set) {
    if (_setDocuments.isEmpty ||
        _setDocuments.where((element) => element.month == set.month).isEmpty) {
      _createDocumentWith(set);
    } else {
      if (_setDocuments
          .where((element) => element.month == set.month)
          .first
          .addSet(set)) _setManager.add(FredericSetEvent(<String>[activityID]));
    }
    if (set.weight > _bestWeight) _bestWeight = set.weight;
    if (set.reps > _bestReps) _bestReps = set.reps;
  }

  void _createDocumentWith(FredericSet set) async {
    var doc = await _setManager.setsCollection.add({
      'activityid': activityID,
      'month': set.month,
      'sets': <Map<String, dynamic>>[set.asMap()]
    });
    _setDocuments.add(
        FredericSetDocument(doc.id, set.month, activityID, <FredericSet>[set]));
    _setManager.add(FredericSetEvent(<String>[activityID]));
  }

  void loadData(int monthsToLoad) async {
    int lastMonth = _setManager.currentMonth - (monthsToLoad - 1);
    QuerySnapshot<Map<String, dynamic>> snapshot = await _setManager
        .setsCollection
        .where('activityid', isEqualTo: activityID)
        .where('month', isGreaterThanOrEqualTo: lastMonth)
        .get();

    _setDocuments.clear();
    for (DocumentSnapshot<Map<String, dynamic>> document in snapshot.docs) {
      int? month = document.data()?['month'];
      if (month == null) continue;

      List<FredericSet> sets = <FredericSet>[];
      List<dynamic>? setList = document.data()?['sets'];

      if (setList == null) continue;

      for (Map<String, dynamic> map in setList) {
        sets.add(FredericSet.fromMap(map));
      }
      _setDocuments
          .add(FredericSetDocument(document.id, month, activityID, sets));
    }
    _calculateBestProgress();
    _setManager.add(FredericSetEvent(<String>[activityID]));
  }
}
