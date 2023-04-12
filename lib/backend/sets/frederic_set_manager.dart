import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/backend/sets/set_time_series_data_representation.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';

class FredericSetManager extends Bloc<FredericSetEvent, FredericSetListData> {
  FredericSetManager([FredericActivityManager? activityManager])
      : super(FredericSetListData(
            changedActivities: <String>[],
            sets: HashMap<String, FredericSetList>(),
            setsByTime: HashMap<DateTime, TimeSeriesSetData>(),
            optimizedBestSetsByDay: HashMap<String, List<double?>>(),
            muscleSplit: List<int>.filled(5, 0),
            weeklyTrainingVolume: List<int>.filled(28, 0))) {
    on<FredericSetEvent>(_onEvent);

    if (activityManager != null) {
      timeSeriesDataRepresentation =
          SetTimeSeriesDataRepresentation(activityManager, this);
    }
  }

  SetTimeSeriesDataRepresentation? timeSeriesDataRepresentation;

  final int currentMonth = FredericSetDocument.calculateMonth(DateTime.now());
  static final int startingYear = 2021;

  HashMap<String, FredericSetList> _sets = HashMap<String, FredericSetList>();

  HashMap<String, FredericSetList> get sets => _sets;

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

  FutureOr<void> _onEvent(
      FredericSetEvent event, Emitter<FredericSetListData> emit) async {
    final profiler = FredericProfiler.track('SetManager onEvent');
    final data = FredericSetListData(
      changedActivities: event.changedActivities,
      sets: _sets,
      setsByTime: timeSeriesDataRepresentation!.timeSeriesData,
      optimizedBestSetsByDay:
          timeSeriesDataRepresentation!.optimizedBestSetData,
      muscleSplit: timeSeriesDataRepresentation!.getMuscleGroupSplit(),
      weeklyTrainingVolume: timeSeriesDataRepresentation!.getVolumeXDays(28),
    );
    profiler.stop();
    emit(data);
  }

  FutureOr<void> initializeDataRepresentations() async {
    await timeSeriesDataRepresentation?.initialize(clearCachedData: false);
    add(FredericSetEvent(['data representations initialized']));
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

    if (fullReloadFromDB) {
      await timeSeriesDataRepresentation?.initialize(clearCachedData: true);
    }

    add(FredericSetEvent(documentMap.keys.toList()));
  }

  void addSet(FredericActivity activity, FredericSet set) async {
    //TODO: Why is this state[activityid] and not _sets[activityid]?
    await state[activity.id].addSet(set, dataInterface);

    timeSeriesDataRepresentation?.addSet(activity, set);

    add(FredericSetEvent([activity.id]));
  }

  void deleteSet(FredericActivity activity, FredericSet set) async {
    //TODO: Why is this state[activityid] and not _sets[activityid]?
    await state[activity.id].deleteSet(set, dataInterface);

    timeSeriesDataRepresentation?.deleteSet(activity, set);

    add(FredericSetEvent([activity.id]));
  }
}

class FredericSetEvent {
  FredericSetEvent(this.changedActivities);

  final List<String> changedActivities;

  bool operator ==(other) => false;

  @override
  int get hashCode => changedActivities.hashCode;
}
