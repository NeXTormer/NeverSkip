import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/sets/set_data_representation.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';

class SetTimeSeriesDataRepresentation implements SetDataRepresentation {
  SetTimeSeriesDataRepresentation(this.activityManager, this.setManager);

  final FredericSetManager setManager;
  final FredericActivityManager activityManager;

  List<TimeSeriesSet> list = [];

  SplayTreeMap<DateTime, FredericSet> map = SplayTreeMap();

  FutureOr<void> initialize({required bool clearCachedData}) {
    // TODO: implement initialize

    FredericProfiler.log(
        'Init SetTimeSeriesDataRepresentation NOT IMPLEMENTED');
    //throw UnimplementedError();
  }

  Map<FredericActivity, List<FredericSet>> getSetsBetween(
      DateTime start, DateTime end) {
    return {};
  }

  Map<FredericActivity, List<FredericSet>> getLastWorkout(
      {int maxDaysAgo = 2,
      Duration maxTimeBetweenSets = const Duration(hours: 1)}) {
    return {};
  }

  void addSet(FredericActivity activity, FredericSet set) {
    return;
    if (list.isNotEmpty && set.timestamp.isAfter(list.last.set.timestamp)) {
      list.add(TimeSeriesSet(activity.id, set));
    } else {
      //TODO: find where to put it using custom binary search

      //list.insert(index, element)
    }
  }

  void deleteSet(FredericActivity activity, FredericSet set) {
    return;
    int index = binarySearch(list, TimeSeriesSet(activity.id, set));
    if (index == -1) return;

    list.removeAt(index);
  }
}

// no two Sets from one user should have the exact same timestamp,
// so only comparing the timestamp should work
class TimeSeriesSet implements Comparable<TimeSeriesSet> {
  TimeSeriesSet(this.activityID, this.set);

  String activityID;
  FredericSet set;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSeriesSet &&
          runtimeType == other.runtimeType &&
          set.timestamp == other.set.timestamp;

  @override
  int get hashCode => set.timestamp.hashCode;

  @override
  int compareTo(TimeSeriesSet other) {
    return set.timestamp.compareTo(other.set.timestamp);
  }
}
