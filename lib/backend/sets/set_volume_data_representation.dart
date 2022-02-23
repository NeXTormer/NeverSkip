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
class SetVolumeDataRepresentation implements SetDataRepresentation {
  SetVolumeDataRepresentation(this.activityManager, this.setManager);

  final FredericSetManager setManager;
  final FredericActivityManager activityManager;

  HashMap<DateTime, VolumeDataRepresentation> _data =
      HashMap<DateTime, VolumeDataRepresentation>();

  HashMap<DateTime, VolumeDataRepresentation> get volume => _data;

  Box<Map<dynamic, dynamic>>? _box;

  @override
  Future<void> initialize() async {
    var profiler;
    //await Hive.deleteBoxFromDisk('SetVolumeDataRepresentation');
    if (_box == null) _box = await Hive.openBox('SetVolumeDataRepresentation');
    if (_box!.isEmpty) {
      profiler = FredericProfiler.track('Calculate SetVolume');
      for (var setList in setManager.sets.values) {
        final setIterator = setList.getAllSets();
        final activity = activityManager[setList.activityID];
        for (var set in setIterator) {
          _addDataToChart(activity, set);
        }
      }

      await _box!.put(0, Map<DateTime, VolumeDataRepresentation>.of(_data));
    } else {
      profiler = FredericProfiler.track('Load SetVolume');
      final data = _box!.getAt(0);
      if (data == null) {
        await _box!.clear();
        initialize();
        return;
      }
      _data = HashMap<DateTime, VolumeDataRepresentation>.from(data);
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

  void _addDataToChart(FredericActivity? activity, FredericSet set) {
    final day =
        DateTime(set.timestamp.year, set.timestamp.month, set.timestamp.day);
    if (!_data.containsKey(day)) {
      _data[day] =
          VolumeDataRepresentation(0, 0, 0, set.timestamp.hashCode.toString());
    }

    final dayData = _data[day]!;
    dayData.sets += 1;
    dayData.reps += set.reps;
    dayData.volume += set.reps * (set.weight == 0 ? 50 : set.weight);
    if (activity != null) {
      for (final muscleGroup in activity.muscleGroups) {
        dayData.muscleGroupReps[dayData.getMuscleGroupID(muscleGroup)] +=
            set.reps;
      }
    }

    _updateCachedData();
  }

  void _removeDataFromChart(FredericActivity activity, FredericSet set) {
    final day =
        DateTime(set.timestamp.year, set.timestamp.month, set.timestamp.day);

    final dayData = _data[day]!;
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
    await _box!.put(0, Map<DateTime, VolumeDataRepresentation>.of(_data));
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
class VolumeDataRepresentation implements FredericDataObject {
  VolumeDataRepresentation(this.sets, this.reps, this.volume, this.id)
      : muscleGroupReps = List.filled(5, 0);

  VolumeDataRepresentation.fromMap(String id, Map<String, dynamic> data)
      : this.id = id,
        this.reps = 0,
        this.sets = 0,
        this.volume = 0,
        this.muscleGroupReps = <double>[] {
    fromMap(id, data);
  }

  String id;
  int reps;
  int sets;
  double volume;
  List<double> muscleGroupReps;

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
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'sets': sets,
      'volume': volume,
      'musclegroups': muscleGroupReps
    };
  }
}
