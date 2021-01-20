import 'package:flutter/material.dart';

class FredericActivity {
  const FredericActivity(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.image,
      @required this.owner});

  final String id;
  final String name;
  final String description;
  final String image;
  final String owner;

  @override
  String toString() {
    return 'FredericActivity[name: $name, description: $description, owner: $owner]';
  }
}
