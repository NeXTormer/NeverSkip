import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FredericProfiler {
  static final bool profilerDisabled = false;

  FredericProfiler.track(this.component, {this.description}) {
    if (profilerDisabled) return;
    _stopwatch = Stopwatch();
    _stopwatch!.start();
    if (!_profilers.containsKey(component)) {
      _profilers[component] = <FredericProfiler>[];
    }
    _profilers[component]!.add(this);
  }

  static HashMap<String, List<FredericProfiler>> _profilers =
      HashMap<String, List<FredericProfiler>>();

  static void evaluate() {
    if (profilerDisabled) return;
    log('Completed Profilers:');
    for (var profilerList in _profilers.entries) {
      //each component
      double minimum = double.infinity;
      double maximum = 0;
      double sum = 0;
      int count = 0;
      double average = 0;
      for (var profiler in profilerList.value) {
        if (!profiler._stopwatch!.isRunning) {
          double timeInMilliseconds =
              profiler._stopwatch!.elapsedMicroseconds / 1000.0;
          if (timeInMilliseconds > maximum) maximum = timeInMilliseconds;
          if (timeInMilliseconds < minimum) minimum = timeInMilliseconds;
          sum += timeInMilliseconds;
          count++;
        }
      }
      average = sum / count;
      log('-> ${profilerList.key}: Avg: ${average.toStringAsFixed(4)}, Max: $maximum, Min: $minimum, #$count');
    }
  }

  static Widget evaluateAsWidget() {
    if (profilerDisabled) return Text('No Data: release mode');

    List<Widget> widgets = <Widget>[];

    for (var profilerList in _profilers.entries) {
      //each component
      double minimum = double.infinity;
      double maximum = 0;
      double sum = 0;
      int count = 0;
      double average = 0;
      for (var profiler in profilerList.value) {
        if (!profiler._stopwatch!.isRunning) {
          double timeInMilliseconds =
              profiler._stopwatch!.elapsedMicroseconds / 1000.0;
          if (timeInMilliseconds > maximum) maximum = timeInMilliseconds;
          if (timeInMilliseconds < minimum) minimum = timeInMilliseconds;
          sum += timeInMilliseconds;
          count++;
        }
      }
      average = sum / count;
      widgets.add(Text(
        profilerList.key,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
            '-> Avg: ${average.toStringAsFixed(4)} ms, Max: $maximum ms, Min: $minimum ms, #$count'),
      ));
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Divider(),
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }

  String component;
  String? description;

  Stopwatch? _stopwatch;

  void stop() {
    if (profilerDisabled) return;
    _stopwatch!.stop();
  }

  static final timeFormat =
      DateFormat(DateFormat.HOUR24_MINUTE_SECOND, 'en-US');

  static void log(String text) {
    final now = DateTime.now();
    print(
        '\x1B[34m[${timeFormat.format(now)}.${now.millisecond}]:\x1B[0m $text');
  }
}
