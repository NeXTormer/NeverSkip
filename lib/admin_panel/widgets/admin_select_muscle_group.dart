import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class AdminSelectMuscleGroup extends StatelessWidget {
  const AdminSelectMuscleGroup(
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
      onTap: () => selected ? removeMuscleGroup(group) : addMuscleGroup(group),
      padding: const EdgeInsets.all(6),
      color: selected ? kMainColor : Colors.white,
      child: Text(
        name,
        style: TextStyle(
            fontSize: 15, color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
