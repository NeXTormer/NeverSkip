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
      : _setManager = setManager;

  final String activityID;
  final FredericSetManager _setManager;

  List<FredericSetDocument> _setDocuments = <FredericSetDocument>[];

  int get bestProgress => 0;
  String get progressType => 'kg';

  void deleteSet(FredericSet set) {
    if (_setDocuments
        .where((element) => element.month == set.month)
        .first
        .deleteSet(set))
      _setManager.add(FredericSetEvent(<String>[activityID]));
  }

  void addSet(FredericSet set) {
    if (_setDocuments.isEmpty ||
        _setDocuments.where((element) => element.month == set.month).isEmpty) {
      _createDocumentWith(set);
      _setManager.add(FredericSetEvent(<String>[activityID]));
    } else {
      if (_setDocuments
          .where((element) => element.month == set.month)
          .first
          .addSet(set)) _setManager.add(FredericSetEvent(<String>[activityID]));
    }
  }

  void _createDocumentWith(FredericSet set) {
    _setManager.setsCollection.add({
      'activityid': activityID,
      'month': set.month,
      'sets': <Map<String, dynamic>>[set.asMap()]
    });
  }

  void loadData(int monthsToLoad) async {
    int lastMonth = _setManager.currentMonth - (monthsToLoad - 1);
    _setDocuments.clear();
    QuerySnapshot<Map<String, dynamic>> snapshot = await _setManager
        .setsCollection
        .where('activityid', isEqualTo: activityID)
        .where('month', isGreaterThanOrEqualTo: lastMonth)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> document in snapshot.docs) {
      int? month = document.data()?['month'];
      if (month == null) continue;

      List<FredericSet> sets = <FredericSet>[];
      List<Map<String, dynamic>>? setList = document.data()?['sets'];

      if (setList == null) continue;

      for (Map<String, dynamic> map in setList) {
        sets.add(FredericSet.fromMap(map));
      }
      _setDocuments
          .add(FredericSetDocument(document.id, month, activityID, sets));
    }
    _setManager.add(FredericSetEvent(<String>[activityID]));
  }

  void loadAdditionalMonths(int count) {}
}
