import 'package:frederic/backend/util/event_bus/frederic_system_events.dart';

abstract class FredericEventProcessor {
  bool acceptsEvent(FredericSystemEvent event);
  void processEvent(FredericSystemEvent event);
}
