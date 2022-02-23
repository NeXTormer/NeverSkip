import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/extensions.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';

///
/// Represents all loaded sets of a specific activity. Use this class to add
/// and remove single sets.
///
class FredericSetList {
  FredericSetList.create(this.activityID);

  FredericSetList.fromDocuments(
    this.activityID,
    List<FredericSetDocument> documentList,
  ) {
    _processDocumentList(documentList);
    _calculateBestProgress();
  }

  final String activityID;

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

  // TODO: make _setDocuments an ordered list to optimize it?
  List<FredericSet> getLatestSets([int count = 6]) {
    final profiler = FredericProfiler.track('Get latest sets. Count: $count');
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
    profiler.stop();
    return sets;
  }

  Iterable<FredericSet> getAllSets() sync* {
    int documentIndex = 0;
    int setIndex = -1;
    while (true) {
      setIndex++;
      if (documentIndex >= _setDocuments.length) break;
      if (setIndex >= _setDocuments[documentIndex].sets.length) {
        documentIndex++;
        setIndex = -1;
        continue;
      }

      yield _setDocuments[documentIndex].sets[setIndex];
    }
  }

  List<FredericSet> getTodaysSets([DateTime? day]) {
    day = day ?? DateTime.now();
    List<FredericSet> sets = <FredericSet>[];

    _setDocuments.sort();
    int documentIndex = 0;
    int setIndex = -1;
    while (true) {
      setIndex++;
      if (documentIndex >= _setDocuments.length) break;
      if (setIndex >= _setDocuments[documentIndex].sets.length) {
        documentIndex++;
        setIndex = -1;
        continue;
      }
      _setDocuments[documentIndex].sets.sort();
      FredericSet current = _setDocuments[documentIndex].sets[setIndex];
      if (current.timestamp.isSameDay(day)) {
        sets.add(current);
      } else {
        break;
      }
    }
    sets.sort((a, b) => a.timestamp.compareTo(b.timestamp));

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
  Future<void> deleteSet(FredericSet set,
      FredericDataInterface<FredericSetDocument> dataInterface) async {
    final setDocument =
        _setDocuments.where((element) => element.month == set.monthID).first;
    if (setDocument.sets.remove(set)) {
      if (set.weight >= _bestWeight || set.reps >= _bestReps) {
        _calculateBestProgress();
      }
      await dataInterface.update(setDocument);
    }
  }

  ///
  /// Don't use this, use the method in [FredericSetManager]
  ///
  Future<void> addSet(FredericSet set,
      FredericDataInterface<FredericSetDocument> dataInterface) async {
    final documentsWithCorrectMonth =
        _setDocuments.where((element) => element.month == set.monthID);
    if (_setDocuments.isEmpty || documentsWithCorrectMonth.isEmpty) {
      await _createDocumentWithSet(set, dataInterface);
    } else {
      documentsWithCorrectMonth.first.sets.add(set);
      await dataInterface.update(documentsWithCorrectMonth.first);
    }
    if (set.weight > _bestWeight) _bestWeight = set.weight;
    if (set.reps > _bestReps) _bestReps = set.reps;
  }

  Future<void> _createDocumentWithSet(FredericSet set,
      FredericDataInterface<FredericSetDocument> dataInterface) async {
    var doc = await dataInterface.createFromMap({
      'activityid': activityID,
      'month': set.monthID,
      'sets': <Map<String, dynamic>>[set.asMap()]
    });
    _setDocuments.add(doc);
  }

  void _processDocumentList(List<FredericSetDocument> docList) {
    for (var document in docList) {
      _setDocuments.add(document);
    }
  }
}
