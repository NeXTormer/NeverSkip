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
          SizedBox(width: 24),
          buildElement('Arms', muscleGroups, FredericActivityMuscleGroup.Arms),
          buildElement(
              'Chest', muscleGroups, FredericActivityMuscleGroup.Chest),
          buildElement('Back', muscleGroups, FredericActivityMuscleGroup.Back),
          buildElement('Abs', muscleGroups, FredericActivityMuscleGroup.Core),
          buildElement('Legs', muscleGroups, FredericActivityMuscleGroup.Legs),
          SizedBox(width: 24),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
