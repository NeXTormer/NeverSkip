import 'package:firebase_storage/firebase_storage.dart';

class AdminIconModel {
  AdminIconModel(this.name, this.url, this.tags, this.reference);

  Reference reference;
  String url;
  String name;
  List<String> tags;

  bool matchTags(List<String> searchTags, [bool matchAll = false]) {
    if (matchAll) {
      return _matchAllTags(searchTags);
    } else {
      return _matchAnyTags(searchTags);
    }
  }

  bool _matchAllTags(List<String> searchTags) {
    if (searchTags.isEmpty) return true;
    if (tags.isEmpty) return true;

    for (String searchTag in searchTags) {
      if (!tags.any((element) => element.contains(searchTag))) {
        return false;
      }
    }
    return true;
  }

  bool _matchAnyTags(List<String> searchTags) {
    if (searchTags.isEmpty) return true;
    if (tags.isEmpty) return true;

    for (String tag in tags) {
      if (searchTags.any((element) => tag.contains(element))) return true;
    }
    return false;
  }
}
