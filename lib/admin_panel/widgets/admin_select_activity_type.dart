import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class AdminSelectActivityType extends StatelessWidget {
  const AdminSelectActivityType(
      {required this.selectedType, required this.onChange, Key? key})
      : super(key: key);

  final FredericActivityType selectedType;
  final void Function(FredericActivityType) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 24),
          buildElement('Weighted', selectedType, FredericActivityType.Weighted),
          buildElement(
              'Calisthenics', selectedType, FredericActivityType.Calisthenics),
          buildElement('Stretch', selectedType, FredericActivityType.Time),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget buildElement(String name, FredericActivityType selectedType,
      FredericActivityType type) {
    bool selected = selectedType == type;
    return FredericCard(
      onTap: () => onChange(type),
      padding: const EdgeInsets.all(6),
      color: selected ? theme.mainColor : Colors.white,
      child: Text(
        name,
        style: TextStyle(
            fontSize: 15, color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
