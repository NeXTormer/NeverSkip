import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:intl/intl.dart';

class SetCard extends StatelessWidget {
  SetCard(this.set,
      [this.isCali = false, this.isStretch = false, this.activity]);

  final FredericSet set;
  final FredericActivity activity;
  final bool isStretch;
  final bool isCali;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Divider(),
        Material(
          color: Colors.white,
          child: InkWell(
            onLongPress: (set.isNotFinal && activity != null)
                ? () => showDeleteDialog(context)
                : null,
            child: Row(
              children: [
                Icon(Icons.arrow_forward_ios_outlined, size: 16),
                Text(
                    '${set.reps} repetition${set.reps == 1 ? '' : 's'}${isCali ? '' : ' with ${set.weight}'}'),
                SizedBox(width: 4),
                if (!isCali && !isStretch)
                  Icon(
                    Icons.fitness_center,
                    size: 14,
                  ),
                if (isStretch) Icon(Icons.timer, size: 14),
                SizedBox(width: 4),
                Expanded(
                  child: Container(),
                ),
                Text(
                    "on ${DateFormat.yMMMd().add_Hm().format(set.timestamp.toLocal())}")
              ],
            ),
          ),
        )
      ],
    ));
  }

  void showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete set'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8),
                Text(
                  'Do you want to delete the following set?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${set.reps} repetition${set.reps == 1 ? '' : 's'}${isCali ? '' : ' with ${set.weight}'}'),
                    SizedBox(width: 4),
                    if (!isCali && !isStretch)
                      Icon(
                        Icons.fitness_center,
                        size: 14,
                      ),
                    if (isStretch) Icon(Icons.timer, size: 14),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Delete',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                activity?.removeProgress(set);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
