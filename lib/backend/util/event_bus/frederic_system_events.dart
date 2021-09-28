class FredericSystemEvent {
  FredericSystemEvent(
      {this.type = FredericSystemEventType.Other,
      this.description = 'unnamed event'});
  final FredericSystemEventType type;
  final String description;
}

enum FredericSystemEventType {
  Complex,
  CalendarDayCompleted,
  Other,
}
