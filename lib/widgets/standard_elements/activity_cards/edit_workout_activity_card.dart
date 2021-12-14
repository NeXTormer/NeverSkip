import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

import '../number_wheel.dart';

class EditWorkoutActivityCard extends StatefulWidget {
  const EditWorkoutActivityCard(
    this.activity, {
    this.margin,
    required this.onDelete,
    required this.workout,
    this.editable = true,
    Key? key,
  }) : super(key: key);

  final FredericWorkoutActivity activity;
  final FredericWorkout workout;

  final EdgeInsets? margin;

  final void Function() onDelete;

  final bool editable;

  final Duration animationDuration = const Duration(milliseconds: 200);

  @override
  _EditWorkoutActivityCardState createState() =>
      _EditWorkoutActivityCardState();
}

class _EditWorkoutActivityCardState extends State<EditWorkoutActivityCard> {
  bool deleted = false;

  NumberSliderController repsSliderController = NumberSliderController();
  NumberSliderController setsSliderController = NumberSliderController();

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        animated: true,
        margin: widget.margin,
        height: deleted ? 0 : 70,
        padding: EdgeInsets.all(deleted ? 0 : 10),
        duration: widget.animationDuration,
        child: deleted
            ? null
            : Row(
                children: [
                  AspectRatio(
                    child: PictureIcon(widget.activity.activity.image,
                        mainColor: theme.mainColorInText,
                        accentColor: theme.mainColorLight),
                    aspectRatio: 1,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          widget.editable
                              ? Container(
                                  width: 200,
                                  child: Text(widget.activity.activity.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          //textBaseline: TextBaseline.alphabetic,
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: theme.textColor)),
                                )
                              : Text(widget.activity.activity.name,
                                  overflow: TextOverflow.ellipsis,
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
                              '${widget.activity.sets}',
                              style: TextStyle(
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontSize: 14),
                            ),
                            SizedBox(width: 2),
                            Text(
                                '${widget.activity.sets == 1 ? 'set' : 'sets'}',
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
                            Text(
                                '${widget.activity.reps == 1 ? 'repetition' : 'repetitions'}',
                                style: TextStyle(
                                    color: theme.textColor,
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
                      onTap: handleEdit,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: theme.mainColorInText, width: 1.8)),
                        child: Icon(CupertinoIcons.pencil,
                            color: theme.mainColorInText, size: 24),
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
                            border: Border.all(
                                color: theme.mainColorInText, width: 1.8)),
                        child: Icon(CupertinoIcons.delete,
                            color: theme.mainColorInText, size: 24),
                      ),
                    ),
                ],
              ));
  }

  void handleEdit() {
    repsSliderController.value = widget.activity.reps;
    setsSliderController.value = widget.activity.sets;
    FredericActionDialog.show(
        context: context,
        dialog: FredericActionDialog(
          onConfirm: () {
            widget.activity.reps = repsSliderController.value.toInt();
            widget.activity.sets = setsSliderController.value.toInt();
            FredericBackend.instance.workoutManager
                .updateWorkoutInDB(widget.workout);
            Navigator.of(context).pop();
          },
          child: SelectSetsAndRepsPopup(
            repsSliderController: repsSliderController,
            setsSliderController: setsSliderController,
          ),
          title: widget.activity.activity.name,
        ));
  }

  void handleDelete() {
    setState(() {
      deleted = true;
    });
    Future.delayed(widget.animationDuration)
        .then((value) => widget.onDelete.call());
  }
}

class SelectSetsAndRepsPopup extends StatefulWidget {
  const SelectSetsAndRepsPopup({
    required this.setsSliderController,
    required this.repsSliderController,
    this.hideDescription = false,
    Key? key,
  }) : super(key: key);

  final NumberSliderController setsSliderController;
  final NumberSliderController repsSliderController;
  final bool hideDescription;

  @override
  _SelectSetsAndRepsPopupState createState() => _SelectSetsAndRepsPopupState();
}

class _SelectSetsAndRepsPopupState extends State<SelectSetsAndRepsPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (!widget.hideDescription)
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 8),
              child: Text(
                'Set the desired number of sets and reps for this activity',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
          Container(
            margin: widget.hideDescription
                ? null
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.isDark
                    ? theme.mainColorLight
                    : theme.cardBackgroundColor,
                border: Border.all(color: theme.cardBorderColor)),
            child: Column(
              children: [
                buildSubHeading('Sets', Icons.account_tree_outlined),
                SizedBox(height: 12),
                NumberWheel(
                  controller: widget.setsSliderController,
                  itemWidth: 0.14,
                  numberOfItems: 10,
                  startingIndex: widget.setsSliderController.value.toInt() + 1,
                ),
                SizedBox(height: 12),
                buildSubHeading('Repetitions', Icons.repeat_outlined),
                SizedBox(height: 12),
                NumberWheel(
                    controller: widget.repsSliderController,
                    itemWidth: 0.14,
                    numberOfItems: 100,
                    startingIndex:
                        widget.repsSliderController.value.toInt() + 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: theme.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
