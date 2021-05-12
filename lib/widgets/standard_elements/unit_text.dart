import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class UnitText extends StatelessWidget {
  UnitText(this.value, this.unit,
      {this.valueWeight = FontWeight.w600,
      this.unitWeight = FontWeight.w500,
      this.unitSize = 14,
      this.valueSize = 16}) {
    valueStyle = TextStyle(
        color: kTextColor,
        fontWeight: valueWeight,
        letterSpacing: 0.5,
        fontSize: valueSize);

    unitStyle = TextStyle(
        color: kTextColor,
        fontWeight: unitWeight,
        letterSpacing: 0.5,
        fontSize: unitSize);
  }

  final String value;
  final String unit;

  final FontWeight valueWeight;
  final FontWeight unitWeight;

  final double valueSize;
  final double unitSize;

  late final TextStyle unitStyle;
  late final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: valueStyle),
        SizedBox(width: 2),
        Text(unit, style: unitStyle)
      ],
    );
  }
}
