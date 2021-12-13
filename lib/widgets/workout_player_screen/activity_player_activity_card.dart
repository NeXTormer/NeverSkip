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
      {this.disabled = false, this.onTap, this.finished = false});

  final FredericWorkoutActivity? activity;
  final bool disabled;
  final bool finished;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final bool doneCard = activity == null;
    return Container(
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!doneCard)
            CalendarTimeLine(
              isActive: finished ? false : !disabled,
              finished: finished,
              //activeColor: disabled ? theme.greyColor : theme.mainColor,
            ),
          if (!doneCard) SizedBox(width: 8),
          Expanded(
              child: activity == null
                  ? _DoneCardContent(onTap: onTap)
                  : _CardContent(activity!,
                      disabled: disabled, finished: finished, onTap: onTap))
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent(this.activity,
      {this.onTap, Key? key, this.finished = false, this.disabled = false})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final bool disabled;
  final bool finished;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        onTap: onTap,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            AspectRatio(
              child: PictureIcon(activity.activity.image,
                  mainColor: disabled
                      ? theme.greyTextColor
                      : finished
                          ? theme.positiveColor
                          : theme.mainColorInText,
                  accentColor: disabled
                      ? theme.disabledGreyColor.withAlpha(50)
                      : finished
                          ? theme.positiveColorLight
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

class _DoneCardContent extends StatelessWidget {
  const _DoneCardContent({this.onTap, Key? key}) : super(key: key);

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        onTap: onTap,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            AspectRatio(
              child: PictureIcon.icon(Icons.thumb_up_outlined,
                  mainColor: theme.mainColorInText,
                  accentColor: theme.mainColorLight),
              aspectRatio: 1,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Job! You\'re done for the Day!',
                      maxLines: 2,
                      style: TextStyle(
                          //textBaseline: TextBaseline.alphabetic,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: theme.textColor)),
                  Text(
                    'Click here for more info.',
                    style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
