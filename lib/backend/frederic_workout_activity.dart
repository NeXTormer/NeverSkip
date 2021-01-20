import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/backend/weekday.dart';

///
/// Users can not view the FredericWorkoutActivity from other users, therefore
/// the FredericWorkoutActivity of a Workout contains the current users progress
/// and the methods to modify the progress.
///
/// If the activity is not part of a workout,
///
class FredericWorkoutActivity extends FredericActivity {
  const FredericWorkoutActivity(
      {String id,
      String name,
      String description,
      String image,
      String owner,
      @required this.weekday,
      @required this.order})
      : super(
            id: id,
            name: name,
            description: description,
            image: image,
            owner: owner);

  final Weekday weekday;
  final int order;

  @override
  String toString() {
    return 'FredericWorkoutActivity[name: $name, description: $description, weekday: $weekday, order: $order, owner: $owner]';
  }
}
