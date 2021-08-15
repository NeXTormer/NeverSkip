import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class CalendarActivityCardContent extends StatefulWidget {
  const CalendarActivityCardContent(this.activity, this.onClick,
      {Key? key,
      this.deleteButton = false,
      this.editButton = false,
      this.onEdit,
      this.margin,
      this.state = ActivityCardState.Normal})
      : super(key: key);

  final FredericActivity activity;
  final ActivityCardState state;

  final EdgeInsets? margin;

  final void Function()? onClick;
  final void Function()? onEdit;
  final bool deleteButton;
  final bool editButton;

  final Duration animationDuration = const Duration(milliseconds: 200);

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
        animated: widget.deleteButton,
        margin: widget.margin,
        onTap: widget.deleteButton ? null : widget.onClick,
        height: widget.deleteButton ? (deleted ? 0 : 70) : 90,
        padding: EdgeInsets.all(deleted ? 0 : 10),
        duration: widget.animationDuration,
        child: deleted
            ? null
            : Row(
                children: [
                  AspectRatio(
                    child: PictureIcon(widget.activity.image,
                        mainColor: widget.state == ActivityCardState.Normal
                            ? kMainColor
                            : kGreenColor,
                        accentColor: widget.state == ActivityCardState.Normal
                            ? kMainColorLight
                            : kGreenColorLight),
                    aspectRatio: 1,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(widget.activity.name,
                              style: TextStyle(
                                  //textBaseline: TextBaseline.alphabetic,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor)),
                          Expanded(child: Container()),
                          // if (activity.type == FredericActivityType.Weighted &&
                          //     !deleteButton)
                          //   Icon(ExtraIcons.dumbbell, color: kMainColor, size: 16),
                          // SizedBox(width: 6),
                        ]),
                        Row(
                          children: [
                            Text(
                              '${widget.activity.recommendedReps}',
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
                              '${widget.activity.recommendedSets}',
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
                            Expanded(child: Container()),
                            if (!widget.deleteButton)
                              Icon(ExtraIcons.dots,
                                  color: kGreyColor, size: 20),
                            SizedBox(width: 4)
                          ],
                        )
                      ],
                    ),
                  ),
                  if (widget.editButton)
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: kMainColor, width: 1.8)),
                        child: Icon(CupertinoIcons.pencil,
                            color: kMainColor, size: 24),
                      ),
                    ),
                  if (widget.deleteButton)
                    GestureDetector(
                      onTap: handleDelete,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: kMainColor, width: 1.8)),
                        child: Icon(CupertinoIcons.delete,
                            color: kMainColor, size: 24),
                      ),
                    ),
                ],
              ));
  }

  void handleDelete() {
    setState(() {
      deleted = true;
    });
    Future.delayed(widget.animationDuration)
        .then((value) => widget.onClick?.call());
  }
}
