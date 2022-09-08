import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/home_screen/last_workout/last_workout_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class LastWorkoutActivityList extends StatefulWidget {
  const LastWorkoutActivityList(
      {required this.title,
      this.activityFilter = const <String>[],
      this.inverseActivityFilter = const <String>[],
      required this.setListData,
      required this.lastWorkoutSets,
      required this.activityListData,
      Key? key})
      : super(key: key);

  final Map<String, List<FredericSet>> lastWorkoutSets;
  final String title;
  final List<String> activityFilter;
  final List<String> inverseActivityFilter;
  final FredericActivityListData activityListData;
  final FredericSetListData setListData;

  @override
  State<LastWorkoutActivityList> createState() =>
      _LastWorkoutActivityListState();
}

class _LastWorkoutActivityListState extends State<LastWorkoutActivityList> {
  bool statsHidden = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FredericHeading(
          widget.title,
          fontSize: 14,
          icon: statsHidden
              ? Icons.toggle_off_outlined
              : Icons.toggle_on_outlined,
          onPressed: () => setState(() => statsHidden = !statsHidden),
        ),
      ),
      if (widget.activityFilter.isEmpty)
        for (final pair in widget.lastWorkoutSets.entries)
          if (!widget.inverseActivityFilter.contains(pair.key))
            _LastWorkoutActivityListItem(
                hidePerformance: statsHidden,
                activityID: pair.key,
                activityListData: widget.activityListData,
                sets: pair.value),
      if (widget.activityFilter.isNotEmpty)
        for (String activityID in widget.activityFilter)
          _LastWorkoutActivityListItem(
            hidePerformance: statsHidden,
            activityID: activityID,
            sets: widget.lastWorkoutSets[activityID],
            activityListData: widget.activityListData,
          ),
    ]);
  }
}

class _LastWorkoutActivityListItem extends StatelessWidget {
  const _LastWorkoutActivityListItem(
      {required this.activityID,
      required this.activityListData,
      required this.sets,
      required this.hidePerformance,
      Key? key})
      : super(key: key);

  final bool hidePerformance;
  final String activityID;
  final FredericActivityListData activityListData;
  final List<FredericSet>? sets;

  @override
  Widget build(BuildContext context) {
    if (sets == null || sets!.isEmpty) return Container();
    FredericActivity? activity = activityListData.activities[activityID];
    if (activity == null) return Container();

    int maxReps = -1;
    double maxWeight = -1;
    int setCount = 0;
    for (final set in sets!) {
      if (set.weight > maxWeight) maxWeight = set.weight;
      if (set.reps > maxReps) maxReps = set.reps;
      setCount++;
    }

    num progress =
        activity.type == FredericActivityType.Weighted ? maxWeight : maxReps;

    if (progress.round() == progress) progress = progress.round();

    return LastWorkoutListItem(
        text: activity.name,
        value: '${hidePerformance ? setCount : progress}',
        unit: hidePerformance
            ? (setCount == 1
                ? tr('progress.sets.one')
                : tr('progress.sets.other'))
            : activity.progressUnit,
        iconUrl: activity.image);
  }
}
