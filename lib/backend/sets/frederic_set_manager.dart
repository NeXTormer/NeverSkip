import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/charts/weekly_training_volume_chart_data.dart';
import 'package:frederic/backend/database/frederic_database_document.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';

class FredericSetManager extends Bloc<FredericSetEvent, FredericSetListData> {
  FredericSetManager()
      : super(FredericSetListData(
            changedActivities: <String>[],
            sets: HashMap<String, FredericSetList>(),
            weeklyTrainingVolume: List<int>.filled(7, 0))) {
    setsCollection = FirebaseFirestore.instance
        .collection('users/${FirebaseAuth.instance.currentUser?.uid}/sets');
  }

  WeeklyTrainingVolumeChartData weeklyTrainingVolumeChartData =
      WeeklyTrainingVolumeChartData();

  late final CollectionReference<Map<String, dynamic>> setsCollection;
  final int currentMonth = FredericSetDocument.calculateMonth(DateTime.now());
  static final int startingYear = 2021;

  HashMap<String, FredericSetList> _sets = HashMap<String, FredericSetList>();

  FredericSetList operator [](String value) {
    if (!_sets.containsKey(value))
      _sets[value] = FredericSetList(value, this)..loadData(2);
    return _sets[value]!;
  }

  @override
  void onTransition(
      Transition<FredericSetEvent, FredericSetListData> transition) {
    // print('============');
    // print(transition);
    // print('============');
    super.onTransition(transition);
  }

  @override
  Stream<FredericSetListData> mapEventToState(FredericSetEvent event) async* {
    yield FredericSetListData(
      changedActivities: event.changedActivities,
      sets: _sets,
      weeklyTrainingVolume: weeklyTrainingVolumeChartData.data,
    );
  }

  void reload() {
    loadAllSets(2);
  }

  void addSet(String activityID, FredericSet set) {
    state[activityID].addSetLocally(set);
    weeklyTrainingVolumeChartData.addSet(set);
  }

  void deleteSet(String activityID, FredericSet set) {
    state[activityID].deleteSetLocally(set);
    weeklyTrainingVolumeChartData.removeSet(set);
  }

  void loadAllSets(int monthsToLoad) async {
    int lastMonth = currentMonth - (monthsToLoad - 1);
    print(
        '==================== CURRENT USER ID: ${FirebaseAuth.instance.currentUser?.uid ?? 'NULL'}');
    print('Loading ${setsCollection.path}');
    QuerySnapshot<Map<String, dynamic>> snapshot = await setsCollection
        .where('month', isGreaterThanOrEqualTo: lastMonth)
        .get();
    _sets.clear();
    HashMap<String, List<FredericDatabaseDocument>> documentMap =
        HashMap<String, List<FredericDatabaseDocument>>();
    for (var doc in snapshot.docs) {
      String activityID = doc.data()['activityid'];
      if (!documentMap.containsKey(activityID)) {
        documentMap[activityID] = <FredericDatabaseDocument>[];
      }
      documentMap[activityID]!
          .add(FredericDatabaseDocument(doc.id, doc.data()));
    }

    for (var entry in documentMap.entries) {
      _sets[entry.key] =
          FredericSetList.fromStorageDocumentList(entry.key, entry.value, this);
    }

    weeklyTrainingVolumeChartData.initialize(_sets);
    add(FredericSetEvent(documentMap.keys.toList()));
  }

  void _loadOrAddNewSet(String id) {
    if (!_sets.containsKey(id)) {
      _sets[id] = FredericSetList(id, this)..loadData(2);
    }
    add(FredericSetEvent(<String>[id]));
  }
}

class FredericSetListData {
  FredericSetListData(
      {required this.changedActivities,
      required this.sets,
      required this.weeklyTrainingVolume});
  final List<String> changedActivities;
  final List<int> weeklyTrainingVolume;
  final HashMap<String, FredericSetList> sets;

  FredericSetList operator [](String value) {
    if (!sets.containsKey(value)) {
      FredericBackend.instance.setManager._loadOrAddNewSet(value);
      return FredericSetList(value, FredericBackend.instance.setManager);
    }
    return sets[value]!;
  }

  bool operator ==(other) => false;

  bool hasChanged(String activityID) => changedActivities.contains(activityID);

  @override
  int get hashCode => changedActivities.hashCode + sets.hashCode;
}

class FredericSetEvent {
  FredericSetEvent(this.changedActivities);
  final List<String> changedActivities;
}
