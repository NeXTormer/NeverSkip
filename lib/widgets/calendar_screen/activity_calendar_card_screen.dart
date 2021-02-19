import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/providers/activity.dart';

class ActivityCalendarCard extends StatelessWidget {
  final FredericActivity activityItem;
  final Key key;

  ActivityCalendarCard(this.activityItem, this.key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(activityItem.image),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityItem.name,
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  width: 200,
                  //height: 50,
                  child: AutoSizeText(
                    activityItem.description,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
