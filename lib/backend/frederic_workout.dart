import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';

class FredericWorkout {
  FredericWorkout(
      {@required this.activities,
      @required this.description,
      @required this.image,
      @required this.owner,
      @required this.ownerName});

  List<FredericActivity> activities;
  String description;
  String image;
  String owner;
  String ownerName;

  //todo: methods to get activities by weekday
}
