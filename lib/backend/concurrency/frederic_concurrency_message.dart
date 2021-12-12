import 'package:frederic/backend/util/event_bus/frederic_base_message.dart';

class FredericConcurrencyMessage extends FredericBaseMessage {
  FredericConcurrencyMessage(this.type, [String? description])
      : super(description);

  FredericConcurrencyMessageType type;
}

enum FredericConcurrencyMessageType {
  UserHasAuthenticated,
  CoreDataHasLoaded,
  Other,
  UserSignUp,
}
