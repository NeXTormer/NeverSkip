import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

///
/// The progress monitors below the profile picture, shows the hightest of the
/// latest sets
///
class SmallProgressViewPage extends StatelessWidget {
  SmallProgressViewPage(this.progressMonitors);

  final List<String> progressMonitors;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: FredericBackend.instance().activityManager.hasData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildRow(),
              );
            return CircularProgressIndicator();
          }),
    );
  }

  List<Widget> buildRow() {
    List<Widget> row = List<Widget>();
    for (int i = 0; i < progressMonitors.length; i++) {
      row.add(buildElement(progressMonitors[i]));
    }
    return row;
  }

  Widget buildElement(String activityID) {
    return FredericActivityBuilder(
      type: FredericActivityBuilderType.SingleActivity,
      id: activityID,
      builder: (context, data) {
        FredericActivity activity = data;
        return buildStatisticText(
            '${activity.bestProgress}', '${activity?.name ?? 'loading...'}');
      },
    );
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
