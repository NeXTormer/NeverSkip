import 'package:cloud_firestore/cloud_firestore.dart';

class FredericDateParser {
  /// Parses a date from various formats returned by different backends.
  /// Handles:
  /// - Firebase [Timestamp]
  /// - ISO 8601 strings (PocketBase)
  /// - [DateTime] objects
  static DateTime? parse(dynamic data) {
    if (data == null) return null;
    if (data is DateTime) return data;
    if (data is Timestamp) return data.toDate();
    if (data is String) {
      return DateTime.tryParse(data);
    }
    return null;
  }

  /// Serializes a [DateTime] for the active backend.
  /// If [usePocketBase] is true, returns an ISO 8601 string.
  /// Otherwise returns a Firebase [Timestamp].
  static dynamic serialize(DateTime? date, {bool usePocketBase = false}) {
    if (date == null) return null;
    if (usePocketBase) {
      return date.toIso8601String();
    }
    return Timestamp.fromDate(date);
  }
}
