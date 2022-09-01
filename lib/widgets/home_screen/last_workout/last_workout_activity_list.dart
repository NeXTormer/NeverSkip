import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/home_screen/last_workout/last_workout_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class LastWorkoutActivityList extends StatefulWidget {
  const LastWorkoutActivityList(
      {required this.title,
      required this.activities,
      required this.setListData,
      required this.activityListData,
      Key? key})
      : super(key: key);

  final String title;
  final List<String> activities;
  final FredericActivityListData activityListData;
  final FredericSetListData setListData;

  @override
  State<LastWorkoutActivityList> createState() =>
      _LastWorkoutActivityListState();
}

class _LastWorkoutActivityListState extends State<LastWorkoutActivityList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FredericHeading(
          'Personal records',
          fontSize: 14,
        ),
      ),
      for (String activityID in widget.activities)
        Builder(builder: (context) {
          FredericActivity? activity =
              widget.activityListData.activities[activityID];
          if (activity == null) return Container();
          return LastWorkoutListItem(
              text: activity.name,
              value: '80',
              unit: activity.progressUnit,
              iconUrl: activity.image);
        }),
    ]);
  }
}
