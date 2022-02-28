import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/add_progress_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CalendarActivityCardContent extends StatefulWidget {
  const CalendarActivityCardContent(this.activity,
      {Key? key, this.state = ActivityCardState.Normal, this.onClick})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final ActivityCardState state;

  final void Function()? onClick;

  @override
  _CalendarActivityCardContentState createState() =>
      _CalendarActivityCardContentState();
}

class _CalendarActivityCardContentState
    extends State<CalendarActivityCardContent> {
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        onTap: () => handleClick(context),
        height: 90,
        padding: EdgeInsets.all(deleted ? 0 : 10),
        child: deleted
            ? null
            : Row(
                children: [
                  AspectRatio(
                    child: PictureIcon(widget.activity.activity.image,
                        mainColor: widget.state == ActivityCardState.Normal
                            ? theme.mainColorInText
                            : theme.positiveColor,
                        accentColor: widget.state == ActivityCardState.Normal
                            ? theme.mainColorLight
                            : theme.positiveColorLight),
                    aspectRatio: 1,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Flexible(
                            child: Text(
                                widget.activity.activity.getNameLocalized(
                                    context.locale.languageCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    //textBaseline: TextBaseline.alphabetic,
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: theme.textColor)),
                          ),
                          //Expanded(child: Container()),
                        ]),
                        Row(
                          children: [
                            Text(
                              '${widget.activity.sets}',
                              style: TextStyle(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontSize: 14),
                            ),
                            SizedBox(width: 2),
                            Text(
                                '${widget.activity.sets == 1 ? tr('progress.sets.one') : tr('progress.sets.other')}',
                                style: TextStyle(
                                    color: theme.textColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    fontSize: 12)),
                            SizedBox(width: 6),
                            FredericVerticalDivider(length: 16),
                            SizedBox(width: 6),
                            Text(
                              '${widget.activity.reps}',
                              style: TextStyle(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontSize: 14),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                  '${widget.activity.reps == 1 ? tr('progress.repetitions.one') : tr('progress.repetitions.other')}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: theme.textColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                      fontSize: 12)),
                            ),
                            //Expanded(child: Container()),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }

  void handleClick(BuildContext context) {
    if (widget.onClick != null) return widget.onClick!();

    CupertinoScaffold.showCupertinoModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (newContext) {
          return BlocProvider.value(
              value: BlocProvider.of<FredericSetManager>(context),
              child: AddProgressScreen(
                widget.activity.activity,
                openedFromCalendar: true,
              ));
        });
  }
}
