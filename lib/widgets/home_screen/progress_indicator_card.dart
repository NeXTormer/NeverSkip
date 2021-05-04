import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/frederic_card.dart';

import '../picture_icon.dart';

class ProgressIndicatorCard extends StatelessWidget {
  ProgressIndicatorCard(this.activityID, {this.loading = false});

  final String activityID;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (activityID == '0') return Container();
    return FredericCard(
      padding: EdgeInsets.all(10),
      child: FredericActivityBuilder(
          type: FredericActivityBuilderType.SingleActivity,
          id: activityID,
          builder: (context, data) {
            FredericActivity activity = data;
            if (activity == null) return Container();
            return Row(
              children: [
                PictureIcon(activity.image),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                            color: const Color(0x7A3A3A3A),
                            fontSize: 10,
                            letterSpacing: 0.3),
                      ),
                      Row(
                        children: [
                          Text(
                            '${activity.bestProgress}',
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 16),
                          ),
                          SizedBox(width: 2),
                          Text(activity.bestProgressType,
                              style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  fontSize: 14))
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
