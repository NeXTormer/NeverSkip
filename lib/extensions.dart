extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime? other) {
    if (other == null) return false;
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool isNotSameDay(DateTime? other) {
    if (other == null) return false;
    return !(this.year == other.year &&
        this.month == other.month &&
        this.day == other.day);
  }
}
