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

  String formattedEuropean() {
    String day = this.day.toString();
    if (this.day < 10) day = day.padLeft(2, '0');
    String month = this.month.toString();
    if (this.month < 10) month = month.padLeft(2, '0');
    return '$day.$month.${this.year}';
  }
}
