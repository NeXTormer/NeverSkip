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
  const LastWorkoutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericActivityManager, FredericActivityListData>(
        builder: (context, activityListData) {
      return BlocBuilder<FredericSetManager, FredericSetListData>(
          builder: (context, setListData) {
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
                  value: '5540',
                  unit: 'kg',
                  icon: ExtraIcons.dumbbell),
              LastWorkoutListItem(
                  text: 'Streak',
                  value: '5',
                  unit: 'days',
                  icon: Icons.local_fire_department_outlined),
              LastWorkoutListItem(
                  text: 'Duration',
                  value: '90',
                  unit: 'min',
                  icon: Icons.timelapse_outlined),
              const SizedBox(height: 8),
              FredericDivider(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FredericHeading(
                  'Personal records',
                  fontSize: 14,
                ),
              ),
              LastWorkoutListItem(
                  text: 'Bench Press',
                  value: '80',
                  unit: 'kg',
                  iconUrl:
                      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe'),
              LastWorkoutListItem(
                  text: 'Bench Press',
                  value: '80',
                  unit: 'kg',
                  iconUrl:
                      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe'),
              LastWorkoutListItem(
                  text: 'Bench Press',
                  value: '80',
                  unit: 'kg',
                  iconUrl:
                      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe'),
              const SizedBox(height: 8),
              LastWorkoutActivityList(
                title: 'Other exercises',
                activities:
                    FredericBackend.instance.userManager.state.progressMonitors,
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
          UnitText(value, unit),
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
