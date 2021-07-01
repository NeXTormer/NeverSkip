import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class CalendarActivityCardContent extends StatelessWidget {
  const CalendarActivityCardContent(this.activity, {Key? key})
      : super(key: key);

  final FredericActivity activity;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        height: 70,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            AspectRatio(
              child: PictureIcon(activity.image),
              aspectRatio: 1,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Text(activity.name,
                        style: TextStyle(
                            //textBaseline: TextBaseline.alphabetic,
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kTextColor)),
                    Expanded(child: Container()),
                    if (activity!.type == FredericActivityType.Weighted)
                      Icon(ExtraIcons.dumbbell, color: kMainColor, size: 16),
                    SizedBox(width: 6),
                  ]),
                  Row(
                    children: [
                      Text(
                        '${activity!.recommendedReps}',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text('reps',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                      SizedBox(width: 6),
                      FredericVerticalDivider(length: 16),
                      SizedBox(width: 6),
                      Text(
                        '${activity!.recommendedSets}',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text('sets',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(ExtraIcons.dots, color: kGreyColor, size: 20)
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
