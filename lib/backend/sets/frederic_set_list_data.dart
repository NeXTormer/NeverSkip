import 'dart:collection';

import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/set_time_series_data_representation.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/extensions.dart';

class FredericSetListData {
  FredericSetListData(
      {required this.changedActivities,
      required this.sets,
      required this.volume,
      required this.weeklyTrainingVolume,
      required this.muscleSplit});

  final List<String> changedActivities;
  final List<int> weeklyTrainingVolume;
  final List<int> muscleSplit;
  final HashMap<String, FredericSetList> sets;
  final HashMap<DateTime, TimeSeriesSetData> volume;

  FredericSetList operator [](String value) {
    if (!sets.containsKey(value)) {
      sets[value] = FredericSetList.create(value);
    }
    return sets[value]!;
  }

  Map<String, List<FredericSet>> getLastWorkoutSets(
      {int maxDaysAgo = 2,
      Duration maxTimeBetweenSets = const Duration(hours: 1)}) {
    Map<String, List<FredericSet>> lastWorkoutSets =
        Map<String, List<FredericSet>>();

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    for (int dayCounter = 0; dayCounter <= maxDaysAgo; dayCounter++) {
      final startOfCurrentDay = today.subtract(Duration(days: dayCounter));

      final setsOnDay = getSetHistoryByDay(startOfCurrentDay);

      if (setsOnDay.isEmpty) continue;

      // if first set of the day is later than maxTimeBetweenSets from 0, it is the whole workout
      DateTime firstSet = now;
      DateTime lastSet = startOfCurrentDay;
      for (final sets in setsOnDay.values) {
        for (final set in sets) {
          if (set.timestamp.isBefore(firstSet)) {
            firstSet = set.timestamp;
          }
          if (set.timestamp.isAfter(lastSet)) {
            lastSet = set.timestamp;
          }
        }
      }

      assert(firstSet.isSameDay(startOfCurrentDay));

      if (firstSet.isAfter(startOfCurrentDay.add(maxTimeBetweenSets))) {
        return setsOnDay;
      }

      // now get the sets from the day before

      final yesterday = startOfCurrentDay.subtract(Duration(days: 1));
      final setsYesterday = getSetHistoryByDay(yesterday);

      if (setsOnDay.isEmpty) return setsOnDay;

      // if first set of the day is later than minTimeBetweenWorkouts from 0, it is the whole workout
      firstSet = now;
      lastSet = startOfCurrentDay;
      for (final sets in setsOnDay.values) {
        for (final set in sets) {
          if (set.timestamp.isBefore(firstSet)) {
            firstSet = set.timestamp;
          }
          if (set.timestamp.isAfter(lastSet)) {
            lastSet = set.timestamp;
          }
        }
      }

      if (lastSet.isBefore(startOfCurrentDay.subtract(maxTimeBetweenSets))) {
        return setsOnDay;
      }

      lastWorkoutSets.clear();
      lastWorkoutSets.addAll(setsOnDay);
      for (final pair in setsYesterday.entries) {
        if (!lastWorkoutSets.containsKey(pair.key)) {
          lastWorkoutSets[pair.key] = <FredericSet>[];
        }
        lastWorkoutSets[pair.key]!.addAll(pair.value);
      }
      return lastWorkoutSets;
    }
    return lastWorkoutSets;
  }

  /// TODO: Caching
  Map<String, List<FredericSet>> getSetHistoryByDay(DateTime day) {
    final profiler =
        FredericProfiler.track('FredericSetManager::getSetHistoryByDay');
    final Map<String, List<FredericSet>> setsOnDay =
        <String, List<FredericSet>>{};

    // TODO: not really efficient because it iterates over every activity
    // TODO: maybe add a dataRepresentation sorted by time
    sets.forEach((activity, setList) {
      final daySets = setList.getTodaysSets(day);
      if (daySets.isNotEmpty) {
        setsOnDay[activity] = daySets;
      }
    });

    profiler.stop();
    return setsOnDay;
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
