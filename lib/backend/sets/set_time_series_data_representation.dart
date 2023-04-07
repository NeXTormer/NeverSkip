import 'dart:collection';

import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/sets/set_data_representation.dart';
import 'package:hive/hive.dart';

import '../activities/frederic_activity.dart';
import '../util/frederic_profiler.dart';

///
/// Need to ensure that all sets and activities are loaded before calling initialize
///
class SetTimeSeriesDataRepresentation implements SetDataRepresentation {
  SetTimeSeriesDataRepresentation(this.activityManager, this.setManager);

  final FredericSetManager setManager;
  final FredericActivityManager activityManager;

  HashMap<DateTime, TimeSeriesSetData> _data =
      HashMap<DateTime, TimeSeriesSetData>();

  HashMap<DateTime, TimeSeriesSetData> get volume => _data;

  Box<Map<dynamic, dynamic>>? _box;

  @override
  Future<void> initialize({required bool clearCachedData}) async {
    var profiler;
    if (_box == null) _box = await Hive.openBox('SetVolumeDataRepresentation');

    if (clearCachedData) {
      await _box?.clear();
    }

    if (_box!.isEmpty) {
      profiler = await FredericProfiler.trackFirebase(
          'Calculate SetVolumeDataRepresentation');
      for (var setList in setManager.sets.values) {
        final setIterator = setList.getAllSets();
        final activity = activityManager[setList.activityID];
        for (var set in setIterator) {
          _addDataToChart(activity, set, updateCachedData: false);
        }
      }
      _updateCachedData();

      await _box!.put(0, Map<DateTime, TimeSeriesSetData>.of(_data));
    } else {
      profiler = await FredericProfiler.trackFirebase(
          'Load SetVolumeDataRepresentation');
      final data = _box!.getAt(0);
      if (data == null) {
        return initialize(clearCachedData: true);
      }
      _data = HashMap<DateTime, TimeSeriesSetData>.from(data);
    }

    profiler.stop();
  }

  List<int> getVolumeXDays([int x = 7]) {
    List<int> list = List.filled(x, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (int i = 0; i < x; i++) {
      final data = _data[today.subtract(Duration(days: i))];
      if (data != null) list[i] = data.volume.toInt();
    }
    list = list.reversed.toList();
    return list;
  }

  List<int> getMuscleGroupSplit() {
    List<int> list = List.filled(5, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (int i = 0; i < 28; i++) {
      final data = _data[today.subtract(Duration(days: i))];
      if (data != null) {
        for (int j = 0; j < 5; j++) {
          list[j] += data.muscleGroupReps[j].toInt();
        }
      }
    }
    return list;
  }

  void _addDataToChart(FredericActivity? activity, FredericSet set,
      {bool updateCachedData = true}) {
    final day =
        DateTime(set.timestamp.year, set.timestamp.month, set.timestamp.day);
    if (!_data.containsKey(day)) {
      _data[day] =
          TimeSeriesSetData(0, 0, 0, set.timestamp.hashCode.toString());
    }

    final dayData = _data[day]!;
    dayData.sets += 1;
    dayData.reps += set.reps;
    dayData.volume += set.reps * (set.weight == 0 ? 50 : set.weight);
    if (activity != null) {
      if (!dayData.allSetsOnDay.containsKey(activity.id)) {
        dayData.allSetsOnDay[activity.id] = <FredericSet>[];
      }

      if (dayData.bestSetOnDay.containsKey(activity.id)) {
        if (activity.type == FredericActivityType.Weighted) {
          if (dayData.bestSetOnDay[activity.id]!.weight < set.weight) {
            dayData.bestSetOnDay[activity.id] = set;
          }
        } else {
          if (dayData.bestSetOnDay[activity.id]!.reps < set.reps) {
            dayData.bestSetOnDay[activity.id] = set;
          }
        }
      } else {
        dayData.bestSetOnDay[activity.id] = set;
      }

      dayData.allSetsOnDay[activity.id]!.add(set);

      for (final muscleGroup in activity.muscleGroups) {
        dayData.muscleGroupReps[dayData.getMuscleGroupID(muscleGroup)] +=
            set.reps;
      }
    }

    if (updateCachedData) _updateCachedData();
  }

  void _removeDataFromChart(FredericActivity activity, FredericSet set) {
    final day =
        DateTime(set.timestamp.year, set.timestamp.month, set.timestamp.day);

    final dayData = _data[day];
    if (dayData == null) return;

    assert(dayData.allSetsOnDay.containsKey(activity.id));
    assert(dayData.bestSetOnDay.containsKey(activity.id));

    dayData.allSetsOnDay[activity.id]!.remove(set);

    if (dayData.bestSetOnDay[activity.id] == set) {
      if (dayData.allSetsOnDay[activity.id]!.isEmpty) {
        dayData.bestSetOnDay.remove(activity.id);
      } else {
        final setList = dayData.allSetsOnDay[activity.id]!;
        FredericSet bestSet = setList.first;
        for (FredericSet temp in setList) {
          if (activity.type == FredericActivityType.Weighted) {
            if (bestSet.weight < temp.weight) {
              bestSet = temp;
            }
          } else {
            if (bestSet.reps < temp.reps) {
              bestSet = temp;
            }
          }
        }
        dayData.bestSetOnDay[activity.id] = bestSet;
      }
    }

    dayData.sets -= 1;
    dayData.reps -= set.reps;
    dayData.volume -= set.reps * set.weight;
    for (final muscleGroup in activity.muscleGroups) {
      dayData.muscleGroupReps[dayData.getMuscleGroupID(muscleGroup)] -=
          set.reps;
    }
    _updateCachedData();
  }

  Future<void> _updateCachedData() async {
    await _box!.put(0, Map<DateTime, TimeSeriesSetData>.of(_data));
  }

  @override
  void addSet(FredericActivity activity, FredericSet set) {
    _addDataToChart(activity, set);
  }

  @override
  void deleteSet(FredericActivity activity, FredericSet set) {
    _removeDataFromChart(activity, set);
  }
}

/// Represents a Day
class TimeSeriesSetData implements FredericDataObject {
  TimeSeriesSetData(this.sets, this.reps, this.volume, this.id)
      : muscleGroupReps = List.filled(5, 0),
        allSetsOnDay = HashMap<String, List<FredericSet>>(),
        bestSetOnDay = HashMap<String, FredericSet>();

  TimeSeriesSetData.fromMap(String id, Map<String, dynamic> data)
      : this.id = id,
        this.reps = 0,
        this.sets = 0,
        this.volume = 0,
        this.muscleGroupReps = <double>[],
        allSetsOnDay = HashMap<String, List<FredericSet>>(),
        bestSetOnDay = HashMap<String, FredericSet>() {
    fromMap(id, data);
  }

  String id;
  int reps;
  int sets;
  double volume;
  List<double> muscleGroupReps;
  Map<String, List<FredericSet>> allSetsOnDay;
  Map<String, FredericSet> bestSetOnDay;

  int getMuscleGroupID(FredericActivityMuscleGroup group) {
    switch (group) {
      case FredericActivityMuscleGroup.Chest:
        return 0;
      case FredericActivityMuscleGroup.Arms:
        return 1;
      case FredericActivityMuscleGroup.Back:
        return 2;
      case FredericActivityMuscleGroup.Legs:
        return 3;
      case FredericActivityMuscleGroup.Core:
        return 4;
      case FredericActivityMuscleGroup.None:
        return 5;
    }
  }

  @override
  void fromMap(String id, Map<String, dynamic> data) {
    this.id = id;
    this.reps = data['reps'];
    this.sets = data['sets'];
    this.volume = data['volume'];
    this.muscleGroupReps = data['musclegroups'];
    this.allSetsOnDay = HashMap<String, List<FredericSet>>();
    this.bestSetOnDay = HashMap<String, FredericSet>();

    if (data['allsetsonday'] != null) {
      Map<dynamic, dynamic> temp = data['allsetsonday'];

      for (var entry in temp.entries) {
        assert(entry.key is String);
        this.allSetsOnDay[entry.key] = List<FredericSet>.from(entry.value);
      }
    }

    if (data['bestsetonday'] != null) {
      bestSetOnDay = HashMap<String, FredericSet>.from(data['bestsetonday']);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'sets': sets,
      'volume': volume,
      'musclegroups': muscleGroupReps,
      'allsetsonday': allSetsOnDay,
      'bestsetonday': bestSetOnDay
    };
  }
}
