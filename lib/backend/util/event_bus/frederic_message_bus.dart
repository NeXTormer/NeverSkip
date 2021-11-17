import 'dart:collection';

import 'package:frederic/backend/util/event_bus/frederic_base_message.dart';
import 'package:frederic/backend/util/event_bus/frederic_default_message_processor.dart';
import 'package:frederic/backend/util/event_bus/frederic_message_processor.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';

class FredericMessageBus {
  FredericMessageBus() {
    _processors.add(_defaultMessageProcessor);
  }

  static const bool kMonitorPerformance = true;

  final Queue<FredericBaseMessage> _queue = ListQueue<FredericBaseMessage>(10);
  final List<FredericMessageProcessor> _processors =
      <FredericMessageProcessor>[];

  FredericDefaultMessageProcessor _defaultMessageProcessor =
      FredericDefaultMessageProcessor();

  FredericDefaultMessageProcessor get defaultProcessor =>
      _defaultMessageProcessor;

  bool _shouldProcessMessagesThisLoop = false;

  void addMessageProcessor(FredericMessageProcessor processor) {
    _processors.add(processor);
  }

  void removeMessageProcessor(FredericMessageProcessor processor) {
    _processors.remove(processor);
  }

  void add(FredericBaseMessage message) {
    _queue.add(message);
    if (_shouldProcessMessagesThisLoop == false) {
      _shouldProcessMessagesThisLoop = true;
      Future(_processMessages);
    }
  }

  void _processMessages() {
    FredericProfiler? profiler;
    if (kMonitorPerformance)
      profiler =
          FredericProfiler.track('[FredericMessageBus] process message queue');
    _shouldProcessMessagesThisLoop = false;
    while (_queue.isNotEmpty) {
      var event = _queue.removeFirst();
      _publishMessage(event);
    }
    if (kMonitorPerformance) profiler!.stop();
  }

  void _publishMessage(FredericBaseMessage message) {
    FredericProfiler? profiler;
    for (FredericMessageProcessor processor in _processors) {
      if (!processor.acceptsMessage(message)) continue;
      if (kMonitorPerformance)
        profiler =
            FredericProfiler.track('[FredericEventBus] ${message.description}');
      processor.processMessage(message);
      if (kMonitorPerformance) profiler!.stop();
    }
  }
}
