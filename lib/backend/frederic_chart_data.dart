import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_goal.dart';

/// Highest set per day
class FredericChartData {
  FredericChartData(this.activityID, this.goalType) {
    if (goalType == FredericGoalType.Reps)
      _importantElement = 'reps';
    else if (goalType == FredericGoalType.Weight) _importantElement = 'weight';
  }
  final String activityID;
  final FredericGoalType goalType;

  String _importantElement;

  FredericChartType _type;
  int _typeArgument;

  HashMap<FredericSimpleDate, num> _data;
  List<FredericChartDataPoint> _list;

  StreamController<List<FredericChartDataPoint>> _streamController;

  CollectionReference _setsCollection =
      FirebaseFirestore.instance.collection('sets');

  Stream<List<FredericChartDataPoint>> asStream(FredericChartType type,
      [int typeArgument = 7]) {
    if (_streamController != null) _streamController.close();

    _streamController = StreamController<List<FredericChartDataPoint>>();
    _data = new HashMap<FredericSimpleDate, num>();
    _type = type;
    _typeArgument = typeArgument;

    int daysToLoad = 0;
    if (type == FredericChartType.PreviousNDays)
      daysToLoad = typeArgument;
    else if (type == FredericChartType.CurrentWeek)
      daysToLoad = DateTime.now().weekday;
    else if (type == FredericChartType.CurrentMonth)
      daysToLoad = DateTime.now().day;

    DateTime today = DateTime.now().subtract(
        Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));

    Query query = _setsCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('activity', isEqualTo: activityID)
        .where('timestamp',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(today.subtract(Duration(days: daysToLoad))))
        .orderBy('timestamp', descending: true);

    query.snapshots().listen(_handleStream);
    return _streamController.stream;
  }

  void _handleStream(QuerySnapshot snapshot) {
    for (int i = 0; i < snapshot.docs.length; i++) {
      var newData = snapshot.docChanges[i].doc.data();
      num value = newData[_importantElement];
      DateTime time = newData['timestamp'].toDate();
      FredericSimpleDate date =
          FredericSimpleDate(time.day, time.month, time.year);
      if (value > _data[date] ?? 0) _data[date] = value;
    }

    _list = List<FredericChartDataPoint>();
    _data
        .forEach((key, value) => _list.add(FredericChartDataPoint(value, key)));
    _list.sort();
    _streamController.add(_list);
  }
}

class FredericChartDataPoint extends Comparable {
  FredericChartDataPoint(this.value, this.date);

  final num value;
  final FredericSimpleDate date;

  @override
  int compareTo(other) {
    int yeardiff = date.year - other.year;
    int monthdiff = date.month - other.month;
    int daydiff = date.day - other.day;
    return yeardiff * 365 + monthdiff * 30 + daydiff;
  }
}

class FredericSimpleDate {
  const FredericSimpleDate(this.day, this.month, this.year);

  final int day;
  final int month;
  final int year;
}

enum FredericChartType {
  /// The current week, e.g. if today is Wednesday, this includes:
  /// Monday, Tuesday, and Wednesday
  CurrentWeek,

  /// The current month, e.g. if today is the 10th of the month, this includes
  /// all days between the 1st and the 10th
  CurrentMonth,

  /// The previous N amount of days, e.g. if N is 7 and today is Wednesday, this
  /// includes all days between last weeks Wednesday and today
  ///
  /// The N has to be specified seperately. if nothing is specified, the default
  /// of 7 is used
  PreviousNDays,
}
