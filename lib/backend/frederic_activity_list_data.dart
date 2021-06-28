class FredericActivityListData {
  FredericActivityListData(this.changed);

  List<String> changed;

  @override
  bool operator ==(Object other) {
    return identical(this, other);
  }

  @override
  int get hashCode => changed.hashCode;
}
