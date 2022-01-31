import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/charts/weekly_training_volume_chart_data.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';

class FredericSetManager extends Bloc<FredericSetEvent, FredericSetListData> {
  FredericSetManager()
      : super(FredericSetListData(
            changedActivities: <String>[],
            sets: HashMap<String, FredericSetList>(),
            weeklyTrainingVolume: List<int>.filled(7, 0)));

  WeeklyTrainingVolumeChartData weeklyTrainingVolumeChartData =
      WeeklyTrainingVolumeChartData();

  final int currentMonth = FredericSetDocument.calculateMonth(DateTime.now());
  static final int startingYear = 2021;

  HashMap<String, FredericSetList> _sets = HashMap<String, FredericSetList>();

  late final FredericDataInterface<FredericSetDocument> dataInterface;

  bool _canFullReload = true;

  FredericSetList operator [](String value) {
    if (!_sets.containsKey(value)) _sets[value] = FredericSetList.create(value);
    return _sets[value]!;
  }

  void setDataInterface(FredericDataInterface<FredericSetDocument> interface) =>
      dataInterface = interface;

  Future<void> triggerManualFullReload() async {
    if (_canFullReload) {
      _canFullReload = false;
      Timer(Duration(seconds: 5), () {
        _canFullReload = true;
      });
      return reload(true);
    } else {
      return Future.delayed(Duration(milliseconds: 50));
    }
  }

  @override
  Stream<FredericSetListData> mapEventToState(FredericSetEvent event) async* {
    yield FredericSetListData(
      changedActivities: event.changedActivities,
      sets: _sets,
      weeklyTrainingVolume: weeklyTrainingVolumeChartData.data,
    );
  }

  Future<void> reload([bool fullReloadFromDB = false]) async {
    _sets.clear();
    HashMap<String, List<FredericSetDocument>> documentMap =
        HashMap<String, List<FredericSetDocument>>();

    final documents =
        await (fullReloadFromDB ? dataInterface.reload() : dataInterface.get());
    for (var doc in documents) {
      if (!documentMap.containsKey(doc.activityID)) {
        documentMap[doc.activityID] = <FredericSetDocument>[];
      }
      documentMap[doc.activityID]!.add(doc);
    }

    for (var entry in documentMap.entries) {
      _sets[entry.key] = FredericSetList.fromDocuments(entry.key, entry.value);
    }

    weeklyTrainingVolumeChartData.initialize(_sets);
    add(FredericSetEvent(documentMap.keys.toList()));
  }

  void addSet(String activityID, FredericSet set) async {
    await state[activityID].addSet(set, dataInterface);
    weeklyTrainingVolumeChartData.addSet(set);
    add(FredericSetEvent([activityID]));
  }

  void deleteSet(String activityID, FredericSet set) async {
    await state[activityID].deleteSet(set, dataInterface);
    weeklyTrainingVolumeChartData.removeSet(set);
    add(FredericSetEvent([activityID]));
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
      sets[value] = FredericSetList.create(value);
    }
    return sets[value]!;
  }

  List<FredericSet> getTodaysSets(FredericActivity activity, [DateTime? day]) {
    day = day ?? DateTime.now();
    FredericSetList setList = this[activity.id];

    return setList.getTodaysSets(day);
  }

  bool operator ==(other) => false;

  bool hasChanged(String activityID) => changedActivities.contains(activityID);

  @override
  int get hashCode => changedActivities.hashCode + sets.hashCode;
}

class FredericSetEvent {
  FredericSetEvent(this.changedActivities);
  final List<String> changedActivities;

  bool operator ==(other) => false;

  @override
  int get hashCode => changedActivities.hashCode;
}
