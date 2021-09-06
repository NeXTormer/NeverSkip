import 'dart:collection';

import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';

class WeeklyTrainingVolumeChartData {
  WeeklyTrainingVolumeChartData();

  final int calisthenicsWeight = 50;

  List<int> data = List<int>.filled(7, 0);
  DateTime? startOfWeek;

  void initialize(HashMap<String, FredericSetList> initialData) {
    var profiler =
        FredericProfiler.track('Initialize WeeklyTrainingVolumeChart');
    DateTime now = DateTime.now();
    startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    bool needsPreviousMonth = now.month != startOfWeek!.month;
    int currentMonth = FredericSetDocument.calculateMonth(now);
    int minimumMonth = needsPreviousMonth ? currentMonth - 1 : currentMonth;

    data = List<int>.filled(7, 0);

    for (var setList in initialData.values) {
      for (var setDocument in setList.setDocuments) {
        if (setDocument.month < minimumMonth) continue;
        for (var set in setDocument.sets) {
          _addDataToChart(set);
        }
      }
    }
    profiler.stop();
  }

  void _addDataToChart(FredericSet set) {
    if (set.timestamp.isAfter(startOfWeek!)) {
      int weight = set.weight;
      if (weight == 0) weight = calisthenicsWeight;
      int volume = weight * set.reps;
      data[set.timestamp.weekday - 1] += volume;
    }
  }

  void _removeDataFromChart(FredericSet set) {
    if (set.timestamp.isAfter(startOfWeek!)) {
      int weight = set.weight;
      if (weight == 0) weight = calisthenicsWeight;
      int volume = weight * set.reps;
      data[set.timestamp.weekday - 1] -= volume;
    }
  }

  void addSet(FredericSet set) {
    if (startOfWeek == null) return;
    _addDataToChart(set);
  }

  void removeSet(FredericSet set) {
    if (startOfWeek == null) return;
    _removeDataFromChart(set);
  }

  List<int> getData() {
    return data;
  }
}
