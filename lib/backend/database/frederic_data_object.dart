abstract class FredericDataObject {
  String get id;

  void fromMap(String id, Map<String, dynamic> data);
  Map<String, dynamic> toMap();
}
