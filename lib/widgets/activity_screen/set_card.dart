import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:intl/intl.dart';

class SetCard extends StatelessWidget {
  SetCard(this.set, [this.isCali = false]);

  final FredericSet set;
  final bool isCali;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Divider(),
        Row(
          children: [
            Icon(Icons.arrow_forward_ios_outlined, size: 16),
            Text(
                '${set.reps} repetition${set.reps == 1 ? '' : 's'}${isCali ? '' : ' with ${set.weight}'}'),
            SizedBox(width: 4),
            if (!isCali)
              Icon(
                Icons.fitness_center,
                size: 14,
              ),
            SizedBox(width: 4),
            Expanded(
              child: Container(),
            ),
            Text(
                "on ${DateFormat.yMMMd().add_Hm().format(set.timestamp.toLocal())}")
          ],
        )
      ],
    ));
  }
}
