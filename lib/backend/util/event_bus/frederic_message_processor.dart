import 'frederic_base_message.dart';

abstract class FredericMessageProcessor {
  bool acceptsMessage(FredericBaseMessage message);
  void processMessage(FredericBaseMessage message);
}
