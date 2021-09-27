class FredericSystemEvent {
  FredericSystemEvent(this.type, {this.description = 'unnamed event'});
  final FredericSystemEventType type;
  final String description;
}

enum FredericSystemEventType {
  Complex,
  CalendarDayCompleted,
}
