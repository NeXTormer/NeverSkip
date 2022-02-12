import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class ActivityTypeSelector extends StatelessWidget {
  const ActivityTypeSelector(
      {required this.selected, required this.onSelect, Key? key})
      : super(key: key);

  final FredericActivityType selected;
  final void Function(FredericActivityType selected) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildElement(
              tr('misc.weighted'),
              selected == FredericActivityType.Weighted,
              FredericActivityType.Weighted),
          buildElement(
              tr('misc.calisthenics'),
              selected == FredericActivityType.Calisthenics,
              FredericActivityType.Calisthenics)
        ],
      ),
    );
  }

  Widget buildElement(String text, bool s, FredericActivityType type) {
    return FredericCard(
      onTap: () => onSelect(type),
      color: s ? theme.mainColor : theme.cardBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: s ? Colors.white : theme.textColor),
      )),
    );
  }
}
