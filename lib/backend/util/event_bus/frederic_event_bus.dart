import 'dart:collection';

import 'package:frederic/backend/util/event_bus/frederic_default_event_processor.dart';
import 'package:frederic/backend/util/event_bus/frederic_event_processor.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';

import 'frederic_system_events.dart';

class FredericEventBus {
  FredericEventBus() {
    _processors.add(_defaultEventProcessor);
  }

  static const bool kMonitorPerformance = true;

  final Queue<FredericSystemEvent> _queue = ListQueue<FredericSystemEvent>(10);
  final List<FredericEventProcessor> _processors = <FredericEventProcessor>[];

  FredericDefaultEventProcessor _defaultEventProcessor =
      FredericDefaultEventProcessor();

  FredericDefaultEventProcessor get defaultProcessor => _defaultEventProcessor;

  bool _shouldProcessEventsThisLoop = false;

  void addEventProcessor(FredericEventProcessor processor) {
    _processors.add(processor);
  }

  void removeEventProcessor(FredericEventProcessor processor) {
    _processors.remove(processor);
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
    for (FredericEventProcessor processor in _processors) {
      if (!processor.acceptsEvent(event)) continue;
      if (kMonitorPerformance)
        profiler =
            FredericProfiler.track('[FredericEventBus] ${event.description}');
      processor.processEvent(event);
      if (kMonitorPerformance) profiler!.stop();
    }
  }
}
