import 'package:frederic/backend/util/event_bus/frederic_message_processor.dart';

import 'frederic_base_message.dart';

typedef FredericEventCallback = void Function(FredericBaseMessage event);

class FredericDefaultMessageProcessor implements FredericMessageProcessor {
  final List<FredericEventCallback> _subscribers = <FredericEventCallback>[];

  @override
  bool acceptsMessage(FredericBaseMessage event) {
    return true;
  }

  @override
  void processMessage(FredericBaseMessage event) {
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
