import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/misc/frederic_text_theme.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/unit_text.dart';

import '../standard_elements/picture_icon.dart';

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
                        style: FredericTextTheme.cardTitleSmall,
                      ),
                      UnitText(
                          '${activity.bestProgress}', activity.bestProgressType)
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
