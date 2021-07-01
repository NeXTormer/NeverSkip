import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/circular_plus_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../backend/backend.dart';
import '../../backend/frederic_activity.dart';
import '../../main.dart';
import '../../screens/add_progress_screen.dart';
import '../standard_elements/frederic_card.dart';
import '../standard_elements/picture_icon.dart';

class FredericRecommendedActivity extends StatelessWidget {
  FredericRecommendedActivity(this.activityId,
      {this.loading = false, this.selectable = false, this.onClick});

  final String activityId;
  final bool loading;
  final bool selectable;
  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    if (activityId == '0') return Container();
    return FredericActivityBuilder(
      type: FredericActivityBuilderType.SingleActivity,
      id: activityId,
      builder: (context, data) {
        FredericActivity activity = data;
        return GestureDetector(
          onTap: () => handleClick(context, activity),
          child: Stack(
            children: [
              FredericCard(
                width: MediaQuery.of(context).size.width / 2.3,
                padding: const EdgeInsets.all(10),
                child: Row(
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
                                '${activity.recommendedReps}',
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
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircularPlusIcon(
                  onPressed: () {},
                  radius: 8,
                  width: 1,
                  iconSize: 14,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void handleClick(BuildContext context, FredericActivity activity) {
    if (selectable) return onClick!();

    showCupertinoModalBottomSheet(
        //expand: true,
        enableDrag: true,
        context: context,
        builder: (context) => AddProgressScreen(activity));
  }
}
