import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_database_document.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/extensions.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';

///
/// Represents all loaded sets of a specific activity. Use this class to add
/// and remove single sets.
///
class FredericSetList {
  FredericSetList(this.activityID, FredericSetManager setManager)
      : _setManager = setManager {
    loadData(2);
  }

  ///
  /// Creates a new FredericSetList from a Query Snapshot. Behaves just like
  /// when using the normal constructor, except that no extra data is loaded and
  /// therefore no event is pushed to the [FredericSetManager]
  ///
  FredericSetList.fromDocumentSnapshot(
      this.activityID,
      QuerySnapshot<Map<String, dynamic>> snapshot,
      FredericSetManager setManager)
      : _setManager = setManager {
    _processQuerySnapshot(snapshot);
    _calculateBestProgress();
  }

  ///
  /// Creates a new FredericSetList from a List of [FredericStorageDocument]s. Behaves just like
  /// when using the normal constructor, except that no extra data is loaded and
  /// therefore no event is pushed to the [FredericSetManager]
  ///
  FredericSetList.fromStorageDocumentList(
      this.activityID,
      List<FredericDatabaseDocument> documentList,
      FredericSetManager setManager)
      : _setManager = setManager {
    _processDocumentList(documentList);
    _calculateBestProgress();
  }

  final String activityID;
  final FredericSetManager _setManager;

  double _bestWeight = 0;
  int _bestReps = 0;

  List<FredericSetDocument> _setDocuments = <FredericSetDocument>[];

  double get bestWeight => _bestWeight;
  int get bestReps => _bestReps;

  List<FredericSetDocument> get setDocuments => _setDocuments;

  bool wasActiveToday() {
    List<FredericSet> latest = getLatestSets(1);
    if (latest.isEmpty) return false;
    return latest[0].timestamp.isSameDay(DateTime.now());
  }

  void loadData(int monthsToLoad) async {
    await FredericBackend.instance.waitUntilUserHasAuthenticated();
    int lastMonth = _setManager.currentMonth - (monthsToLoad - 1);
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users/${FirebaseAuth.instance.currentUser?.uid}/sets')
        .where('activityid', isEqualTo: activityID)
        .where('month', isGreaterThanOrEqualTo: lastMonth)
        .get();

    _setDocuments.clear();
    _processQuerySnapshot(snapshot);
    _calculateBestProgress();
    _setManager.add(FredericSetEvent(<String>[activityID]));
  }

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
    sets.sort();
    return sets;
  }

  //TODO: improve performance maybe
  List<RepsWeightSuggestion> getSuggestions(
      {int count = 6, bool weighted = true, int recommendedReps = 10}) {
    List<RepsWeightSuggestion> list = <RepsWeightSuggestion>[];
    int reps = 0;
    double weight = 0;
    final latestList = getLatestSets(1);
    if (latestList.isNotEmpty) {
      FredericSet latest = latestList.first;
      reps = latest.reps;
      weight = latest.weight;
    }
    if (reps == 0) reps = recommendedReps;
    if (weight == 0) weight = 30;
    if (weighted) {
      if (weight > 10) list.add(RepsWeightSuggestion(reps + 0, weight - 5));
      list.add(RepsWeightSuggestion(reps + 0, weight + 0));
      list.add(RepsWeightSuggestion(reps + 0, weight + 5));
      if (reps > 4 && weight > 10)
        list.add(RepsWeightSuggestion(reps - 2, weight - 5));
      if (reps > 4) list.add(RepsWeightSuggestion(reps - 2, weight + 0));
      list.add(RepsWeightSuggestion(reps + 2, weight + 0));
    } else {
      list.add(RepsWeightSuggestion(reps + 1, null));
      list.add(RepsWeightSuggestion(reps + 2, null));
      list.add(RepsWeightSuggestion(reps + 4, null));
      if (reps > 1) list.add(RepsWeightSuggestion(reps - 1, null));
      if (reps > 2) list.add(RepsWeightSuggestion(reps - 2, null));
      if (reps > 4) list.add(RepsWeightSuggestion(reps - 4, null));
    }

    return list;
  }

  void _calculateBestProgress() {
    for (FredericSetDocument setDoc in _setDocuments) {
      for (FredericSet set in setDoc.sets) {
        if (set.reps > _bestReps) _bestReps = set.reps;
        if (set.weight > _bestWeight) _bestWeight = set.weight;
      }
    }
  }

  ///
  /// Don't use this, use the method in [FredericSetManager]
  ///
  void deleteSetLocally(FredericSet set) {
    if (_setDocuments
        .where((element) => element.month == set.monthID)
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

  ///
  /// Don't use this, use the method in [FredericSetManager]
  ///
  void addSetLocally(FredericSet set) {
    if (_setDocuments.isEmpty ||
        _setDocuments
            .where((element) => element.month == set.monthID)
            .isEmpty) {
      _createDocumentWithSet(set);
    } else {
      if (_setDocuments
          .where((element) => element.month == set.monthID)
          .first
          .addSet(set)) _setManager.add(FredericSetEvent(<String>[activityID]));
    }
    if (set.weight > _bestWeight) _bestWeight = set.weight;
    if (set.reps > _bestReps) _bestReps = set.reps;
  }

  void _createDocumentWithSet(FredericSet set) async {
    var doc = await _setManager.setsCollection.add({
      'activityid': activityID,
      'month': set.monthID,
      'sets': <Map<String, dynamic>>[set.asMap()]
    });
    _setDocuments.add(FredericSetDocument(
        doc.id, set.monthID, activityID, <FredericSet>[set]));
    _setManager.add(FredericSetEvent(<String>[activityID]));
  }

  void _processQuerySnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (DocumentSnapshot<Map<String, dynamic>> document in snapshot.docs) {
      if (document.data() == null) continue;
      if (document.data()?['activityid'] != activityID) continue;
      _insertStorageDocument(
          FredericDatabaseDocument(document.id, document.data()!));
    }
  }

  void _processDocumentList(List<FredericDatabaseDocument> docList) {
    for (var document in docList) {
      _insertStorageDocument(document);
    }
  }

  void _insertStorageDocument(FredericDatabaseDocument document) {
    int? month = document['month'];
    if (month == null) return;

    List<FredericSet> sets = <FredericSet>[];
    List<dynamic>? setList = document['sets'];

    if (setList == null) return;

    for (Map<String, dynamic> map in setList) {
      sets.add(FredericSet.fromMap(map));
    }
    _setDocuments
        .add(FredericSetDocument(document.id, month, activityID, sets));
  }
}
