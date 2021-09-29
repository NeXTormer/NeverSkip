import 'package:frederic/backend/util/event_bus/frederic_event_processor.dart';
import 'package:frederic/backend/util/event_bus/frederic_system_event.dart';

typedef FredericEventCallback = void Function(FredericSystemEvent event);

class FredericDefaultEventProcessor implements FredericEventProcessor {
  final List<FredericEventCallback> _subscribers = <FredericEventCallback>[];

  @override
  bool acceptsEvent(FredericSystemEvent event) {
    return true;
  }

  @override
  void processEvent(FredericSystemEvent event) {
    for (FredericEventCallback subscriber in _subscribers) {
      subscriber.call(event);
    }
  }

  void subscribe(FredericEventCallback callback) {
    _subscribers.add(callback);
  }

  void unsubscribe(FredericEventCallback callback) {
    _subscribers.remove(callback);
  }
}
