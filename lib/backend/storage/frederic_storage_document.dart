class FredericStorageDocument {
  FredericStorageDocument(this.id, this.data);

  final String id;
  final Map<String, dynamic> data;

  dynamic operator [](String key) {
    return data[key];
  }
}
