import 'frederic_base_message.dart';

class FredericSystemMessage extends FredericBaseMessage {
  FredericSystemMessage({
    String? description,
    this.type = FredericSystemMessageType.Other,
  }) : super(description);
  final FredericSystemMessageType type;
}

enum FredericSystemMessageType {
  Complex,
  CalendarDayCompleted,
  Other,
}
