import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:intl/intl.dart';

class CalendarSetWidget extends StatelessWidget {
  const CalendarSetWidget({Key key, @required this.fredericSet})
      : super(key: key);
  final FredericSet fredericSet;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Divider(),
        Row(
          children: [
            SizedBox(width: 54),
            Icon(Icons.arrow_forward_ios_outlined, size: 16),
            Text('${fredericSet.reps} reps with ${fredericSet.weight}'),
            SizedBox(width: 4),
            Icon(
              Icons.fitness_center,
              size: 14,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Container(),
            ),
            Text(
                "on ${DateFormat.yMMMd().add_Hm().format(fredericSet.timestamp.toLocal())}")
          ],
        )
      ],
    ));
  }
}
