import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class AdminSelectFilterType extends StatelessWidget {
  const AdminSelectFilterType(
      {required this.matchAny, required this.onChange, Key? key})
      : super(key: key);

  final bool matchAny;
  final void Function(bool matchAny) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildElement('Match Any', matchAny, true),
          buildElement('Match All', !matchAny, false),
        ],
      ),
    );
  }

  Widget buildElement(String name, bool selected, bool matchAny) {
    return FredericCard(
      borderRadius: 4,
      height: 44,
      onTap: () => onChange(matchAny),
      padding: const EdgeInsets.all(6),
      color: selected ? kMainColor : Colors.white,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              fontSize: 15, color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
