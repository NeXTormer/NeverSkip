import 'package:firebase_storage/firebase_storage.dart';

class AdminIconModel {
  AdminIconModel(this.name, this.url, this.tags, this.reference);

  Reference reference;
  String url;
  String name;
  List<String> tags;
}
