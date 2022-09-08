import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/home_screen/last_workout/last_workout_activity_list.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/unit_text.dart';

class LastWorkoutCard extends StatelessWidget {
  const LastWorkoutCard({this.screenshot = false, Key? key}) : super(key: key);

  final bool screenshot;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericActivityManager, FredericActivityListData>(
        builder: (context, activityListData) {
      return BlocBuilder<FredericSetManager, FredericSetListData>(
          builder: (context, setListData) {
        final lastWorkoutSets = setListData.getLastWorkoutSets();

        DateTime? first;
        DateTime? last;

        double volume = 0;

        for (final sets in lastWorkoutSets.values) {
          for (final set in sets) {
            if (set.weight != 0)
              volume += set.weight * set.reps;
            else
              volume += set.reps * 50;
            if (first?.isAfter(set.timestamp) ?? true) first = set.timestamp;
            if (last?.isBefore(set.timestamp) ?? true) last = set.timestamp;
          }
        }

        return Container(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FredericHeading(
                  'Stats',
                  fontSize: 14,
                ),
              ),
              LastWorkoutListItem(
                  text: 'Total volume',
                  value: '${volume.toInt()}',
                  unit: 'kg',
                  icon: ExtraIcons.dumbbell),
              LastWorkoutListItem(
                  text: 'Current Streak',
                  value: '${FredericBackend.instance.userManager.state.streak}',
                  unit: 'days',
                  icon: Icons.local_fire_department_outlined),
              if (last != null && first != null)
                LastWorkoutListItem(
                    text: 'Duration',
                    value: '${last.difference(first).inMinutes.abs()}',
                    unit: 'min',
                    icon: Icons.timelapse_outlined),
              const SizedBox(height: 8),
              FredericDivider(),
              const SizedBox(height: 8),
              LastWorkoutActivityList(
                title: 'Personal Records',
                hideButton: screenshot,
                activityFilter:
                    FredericBackend.instance.userManager.state.progressMonitors,
                lastWorkoutSets: lastWorkoutSets,
                activityListData: activityListData,
                setListData: setListData,
              ),
              const SizedBox(height: 8),
              LastWorkoutActivityList(
                title: 'Other Exercises',
                hideButton: screenshot,
                inverseActivityFilter:
                    FredericBackend.instance.userManager.state.progressMonitors,
                lastWorkoutSets: lastWorkoutSets,
                activityListData: activityListData,
                setListData: setListData,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      });
    });
  }
}

class LastWorkoutListItem extends StatelessWidget {
  const LastWorkoutListItem(
      {required this.text,
      required this.unit,
      required this.value,
      this.icon,
      this.iconUrl,
      Key? key})
      : super(key: key);

  final String text;
  final String value;
  final String unit;
  final IconData? icon;
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 12, left: 12),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 20,
              color: theme.mainColorInText,
            ),
          if (iconUrl != null)
            Container(
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 32),
                  child: PictureIcon(
                    iconUrl,
                    borderRadius: 6,
                    iconPadding: 5,
                  )),
            ),
          if (icon != null || iconUrl != null) const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.w400,
                fontSize: 15),
          ),
          Expanded(child: Container()),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: UnitText(
                value,
                unit,
                key: ValueKey<int>(value.hashCode + unit.hashCode),
              )),
        ],
      ),
    );
  }
}

///
/// Volume
/// Streak
/// Activity List
/// personal records
///
