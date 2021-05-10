import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:intl/intl.dart';

///
/// Contains the data for an activity which is displayed in a chart
/// Each day in the chart uses the highest weight or rep-count achieved on that day
///
class FredericChartData {
  FredericChartData(this.activityID, this.goalType) {
    if (goalType == FredericGoalType.Reps)
      _importantElement = 'reps';
    else if (goalType == FredericGoalType.Weight) _importantElement = 'weight';
  }
  final String activityID;
  FredericActivity activity;
  final FredericGoalType goalType;

  String _importantElement;

  FredericChartType _type;
  int _typeArgument;

  HashMap<FredericSimpleDate, num> _data;
  List<FredericChartDataPoint> _list;

  StreamController<FredericChartData> _streamController;

  CollectionReference _setsCollection =
      FirebaseFirestore.instance.collection('sets');

  List<FredericChartDataPoint> get data => _list;
  FredericChartType get type => _type;
  int get typeArgument => _typeArgument;

  Stream<FredericChartData> asStream(FredericChartType type,
      [int typeArgument = 7]) {
    if (_streamController != null) _streamController.close();

    _streamController = StreamController<FredericChartData>();
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

  void _handleStream(QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (int i = 0; i < snapshot.docChanges.length; i++) {
      var newData = snapshot.docChanges[i].doc.data();
      num value = newData[_importantElement];
      DateTime time = newData['timestamp'].toDate();
      FredericSimpleDate date =
          FredericSimpleDate(time.day, time.month, time.year);
      if ((value ?? 0) > (_data[date] ?? 0)) _data[date] = value;
    }

    _list = List<FredericChartDataPoint>();
    _data
        .forEach((key, value) => _list.add(FredericChartDataPoint(value, key)));
    _list.sort();
    _streamController.add(this);
  }
}

class FredericChartDataPoint extends Comparable {
  FredericChartDataPoint(this.value, this.date);

  final num value;
  final FredericSimpleDate date;

  @override
  int compareTo(other) {
    int yeardiff = date.year - other.date.year;
    int monthdiff = date.month - other.date.month;
    int daydiff = date.day - other.date.day;
    return yeardiff * 365 + monthdiff * 30 + daydiff;
  }
}

class FredericSimpleDate {
  const FredericSimpleDate(this.day, this.month, this.year);

  final int day;
  final int month;
  final int year;

  static final NumberFormat format = NumberFormat('00');

  @override
  String toString() {
    return '${format.format(day)}.${format.format(month)}';
  }
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
