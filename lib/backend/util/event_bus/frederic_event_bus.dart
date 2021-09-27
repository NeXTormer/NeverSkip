import 'dart:collection';

import 'package:frederic/backend/util/frederic_profiler.dart';

import 'frederic_system_events.dart';

typedef FredericEventCallback = void Function(FredericSystemEvent event);

class FredericEventBus {
  FredericEventBus();
  static const bool kMonitorPerformance = true;

  final Queue<FredericSystemEvent> _queue = ListQueue<FredericSystemEvent>(10);
  final List<FredericEventCallback> _subscribers = <FredericEventCallback>[];

  bool _shouldProcessEventsThisLoop = false;

  void subscribe(FredericEventCallback callback) {
    _subscribers.add(callback);
  }

  void unsubscribe(FredericEventCallback callback) {
    _subscribers.remove(callback);
  }

  void add(FredericSystemEvent event) {
    _queue.add(event);
    if (_shouldProcessEventsThisLoop == false) {
      _shouldProcessEventsThisLoop = true;
      Future(_processEvents);
    }
  }

  void _processEvents() {
    FredericProfiler? profiler;
    if (kMonitorPerformance)
      profiler =
          FredericProfiler.track('[FredericEventBus] process event queue');
    _shouldProcessEventsThisLoop = false;
    while (_queue.isNotEmpty) {
      var event = _queue.removeFirst();
      _publishEvent(event);
    }
    if (kMonitorPerformance) profiler!.stop();
  }

  void _publishEvent(FredericSystemEvent event) {
    FredericProfiler? profiler;
    for (FredericEventCallback subscriber in _subscribers) {
      if (kMonitorPerformance)
        profiler =
            FredericProfiler.track('[FredericEventBus] ${event.description}');
      subscriber.call(event);
      if (kMonitorPerformance) profiler!.stop();
    }
  }
}
