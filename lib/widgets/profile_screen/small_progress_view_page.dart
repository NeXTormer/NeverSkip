import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_progress_snapshot.dart';

class SmallProgressViewPage extends StatelessWidget {
  List<String> activities;

  @override
  Widget build(BuildContext context) {
    activities = FredericBackend.of(context).currentUser.progressMonitors;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildRow(),
      ),
    );
  }

  List<Widget> buildRow() {
    List<Widget> row = List<Widget>();
    for (int i = 0; i < activities.length; i++) {
      FredericProgressSnapshot ps = FredericProgressSnapshot(activities[i],
          FredericGoalType.Weight, FredericProgressSnapshotType.Maximum);
      Widget sb = StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildStatisticText('${snapshot.data}', '${ps.activityName}');
          }

          return Container();
        },
        stream: ps.asStream(),
      );
      row.add(sb);
    }
    return row;
  }

  /// Outsources the Stats-Text section
  ///
  /// Currently builds [subText] above [boldText] in a Column
  Widget buildStatisticText(String boldText, String subText) {
    return Container(
      child: Column(
        children: [
          Text(
            subText,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            boldText,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
