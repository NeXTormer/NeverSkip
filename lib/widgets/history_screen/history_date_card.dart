import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:intl/intl.dart';

class HistoryDateCard extends StatelessWidget {
  HistoryDateCard(this.date, {Key? key, this.formatString = 'd MMMM, y'})
      : format = DateFormat(formatString),
        super(key: key);
  final DateTime date;
  final String formatString;
  final DateFormat format;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      height: 42,
      borderWidth: 0,
      color: theme.mainColorLight,
      child: Center(
          child: Text(
        format.format(date),
        style: TextStyle(
            fontSize: 15,
            color: theme.mainColorInText,
            fontWeight: FontWeight.w500),
      )),
    );
  }
}
