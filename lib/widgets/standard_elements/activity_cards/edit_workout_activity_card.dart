import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class EditWorkoutActivityCard extends StatefulWidget {
  const EditWorkoutActivityCard(
    this.activity, {
    required this.onDelete,
    required this.onEdit,
    this.editable = true,
    Key? key,
  }) : super(key: key);

  final void Function() onDelete;
  final void Function() onEdit;

  final bool editable;

  final Duration animationDuration = const Duration(milliseconds: 200);
  final FredericWorkoutActivity activity;

  @override
  _EditWorkoutActivityCardState createState() =>
      _EditWorkoutActivityCardState();
}

class _EditWorkoutActivityCardState extends State<EditWorkoutActivityCard> {
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        animated: true,
        height: deleted ? 0 : 70,
        padding: EdgeInsets.all(deleted ? 0 : 10),
        duration: widget.animationDuration,
        child: deleted
            ? null
            : Row(
                children: [
                  AspectRatio(
                    child: PictureIcon(widget.activity.activity.image,
                        mainColor: kMainColor, accentColor: kMainColorLight),
                    aspectRatio: 1,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(widget.activity.activity.name,
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
                              '${widget.activity.reps}',
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
                              '${widget.activity.sets}',
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
                            SizedBox(width: 4)
                          ],
                        )
                      ],
                    ),
                  ),
                  if (widget.editable)
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
                  if (widget.editable)
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
    print('delete');
    setState(() {
      deleted = true;
    });
    Future.delayed(widget.animationDuration)
        .then((value) => widget.onDelete.call());
  }
}
