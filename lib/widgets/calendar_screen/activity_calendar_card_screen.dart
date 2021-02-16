import 'package:flutter/material.dart';
import 'package:frederic/providers/activity.dart';

class ActivityCalendarCard extends StatelessWidget {
  final ActivityItem activityItem;
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
                Text(
                  activityItem.description,
                  style: TextStyle(
                    color: Colors.black54,
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
