import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';

class FredericProfiler {
  FredericProfiler.track(this.component, {this.description}) {
    if (kReleaseMode) return;
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
    if (kReleaseMode) return;
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

  String component;
  String? description;

  Stopwatch? _stopwatch;

  void stop() {
    if (kReleaseMode) return;
    _stopwatch!.stop();
  }
}
