import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

import '../../main.dart';

class ActivityMuscleGroupSelector extends StatelessWidget {
  const ActivityMuscleGroupSelector(
      {required this.muscleGroups,
      required this.addMuscleGroup,
      required this.removeMuscleGroup,
      Key? key})
      : super(key: key);

  final List<FredericActivityMuscleGroup> muscleGroups;
  final void Function(FredericActivityMuscleGroup) addMuscleGroup;
  final void Function(FredericActivityMuscleGroup) removeMuscleGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 8),
          buildElement(tr('exercises.muscle_groups.arms'), muscleGroups,
              FredericActivityMuscleGroup.Arms),
          buildElement(tr('exercises.muscle_groups.chest'), muscleGroups,
              FredericActivityMuscleGroup.Chest),
          buildElement(tr('exercises.muscle_groups.back'), muscleGroups,
              FredericActivityMuscleGroup.Back),
          buildElement(tr('exercises.muscle_groups.abs'), muscleGroups,
              FredericActivityMuscleGroup.Core),
          buildElement(tr('exercises.muscle_groups.legs'), muscleGroups,
              FredericActivityMuscleGroup.Legs),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget buildElement(
      String name,
      List<FredericActivityMuscleGroup> selectedGroups,
      FredericActivityMuscleGroup group) {
    bool selected = selectedGroups.contains(group);
    return FredericCard(
        onTap: () =>
            selected ? removeMuscleGroup(group) : addMuscleGroup(group),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        color: selected ? theme.mainColor : theme.cardBackgroundColor,
        child: Center(
            child: Text(
          name,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : theme.textColor),
        )));
  }
}
