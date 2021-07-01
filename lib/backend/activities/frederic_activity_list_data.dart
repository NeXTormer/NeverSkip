import 'dart:collection';

import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_controller.dart';

class FredericActivityListData {
  FredericActivityListData(this.changed, this.activities);

  List<String> changed;
  HashMap<String, FredericActivity> activities;

  List<FredericActivity> getFilteredActivities(
      ActivityFilterController filter) {
    return activities.values
        .where((element) => element.matchFilterController(filter))
        .toList();
  }

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => changed.hashCode;
}
