import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/calendar_screen/calendar_day.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

import '../../main.dart';

class ActivityPlayerActivityCard extends StatelessWidget {
  ActivityPlayerActivityCard(this.activity,
      {this.disabled = false, this.indicator = false});

  final FredericWorkoutActivity activity;
  final bool indicator;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CalendarTimeLine(
            isActive: indicator,
            activeColor: disabled ? theme.greyColor : theme.mainColor,
          ),
          SizedBox(width: 8),
          Expanded(child: _CardContent(activity, disabled: disabled))
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent(this.activity, {Key? key, this.disabled = false})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            AspectRatio(
              child: PictureIcon(activity.activity.image,
                  mainColor:
                      disabled ? theme.greyTextColor : theme.mainColorInText,
                  accentColor: disabled
                      ? theme.disabledGreyColor.withAlpha(50)
                      : theme.mainColorLight),
              aspectRatio: 1,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Text(activity.activity.name,
                        style: TextStyle(
                            //textBaseline: TextBaseline.alphabetic,
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.textColor)),
                    Expanded(child: Container()),
                  ]),
                  Row(
                    children: [
                      Text(
                        '${activity.sets}',
                        style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text('${activity.sets == 1 ? 'set' : 'sets'}',
                          style: TextStyle(
                              color: theme.textColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                      SizedBox(width: 6),
                      FredericVerticalDivider(length: 16),
                      SizedBox(width: 6),
                      Text(
                        '${activity.reps}',
                        style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text(
                          '${activity.reps == 1 ? 'repetition' : 'repetitions'}',
                          style: TextStyle(
                              color: theme.textColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                      Expanded(child: Container()),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
