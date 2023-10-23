import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/workout_list_screen/enable_workout_dialog.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard(this.workout,
      {Key? key, this.name, this.description, this.period, this.repeating})
      : clickable = true,
        super(key: key);

  const WorkoutCard.dummy(this.workout,
      {this.name, this.description, this.period, this.repeating})
      : clickable = false;

  static const bool kCanDeleteWithLongPress = false;

  final String? name;
  final String? description;
  final int? period;
  final bool? repeating;

  final bool clickable;

  final FredericWorkout workout;

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool isSelected = false;
  bool isRepeating = false;

  @override
  void initState() {
    isSelected = FredericBackend.instance.userManager.state.activeWorkouts
        .containsKey(widget.workout.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isRepeating = widget.repeating ?? widget.workout.repeating;

    bool hasStartDate = widget.workout.canEdit ||
        FredericBackend.instance.userManager.state.activeWorkouts
            .containsKey(widget.workout.id);

    return FredericCard(
        height: 114,
        onLongPress: () => handleLongPress(context),
        onTap: widget.clickable
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditWorkoutScreen(
                          widget.workout.id,
                          defaultPage: hasStartDate
                              ? widget.workout.activities
                                  .getDayIndex(DateTime.now())
                              : 0,
                        )));
              }
            : null,
        padding: EdgeInsets.only(top: 12, left: 12, bottom: 10, right: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46,
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: PictureIcon(widget.workout.image,
                        mainColor: theme.mainColorInText),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.name ?? widget.workout.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: theme.textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, right: 2),
                                child: CupertinoSwitch(
                                  key: ValueKey(widget.workout.id),
                                  value: isSelected,
                                  activeColor: theme.mainColor,
                                  onChanged: widget.workout.id == 'new'
                                      ? null
                                      : (value) => handleSwitch(context, value),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FredericChip(
                              '${widget.period ?? widget.workout.period} ${(widget.period ?? widget.workout.period) == 1 ? tr('misc.week') : tr('misc.weeks')}',
                              fontSize: 12,
                            ),
                            SizedBox(width: 10),
                            if (isRepeating)
                              FredericChip(
                                tr('misc.repeating'),
                                fontSize: 12,
                              )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: Text(
                widget.description ?? widget.workout.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color:
                        theme.isBright ? theme.textColor : theme.greyTextColor),
              ),
            )
          ],
        ));
  }

  void handleLongPress(BuildContext context) {
    if (!WorkoutCard.kCanDeleteWithLongPress) return;
    if (widget.workout.canEdit) {
      FredericActionDialog.show(
          context: context,
          dialog: FredericActionDialog(
            title: tr('confirm_delete'),
            actionText: tr('delete'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child:
                  Text(tr('workout.delete_text'), textAlign: TextAlign.center),
            ),
            onConfirm: () {
              FredericBackend.instance.workoutManager
                  .add(FredericWorkoutDeleteEvent(widget.workout));
              Navigator.of(context).pop();
            },
            destructiveAction: true,
          ));
    }
  }

  void handleSwitch(BuildContext context, bool value) {
    EnableDisableWorkoutDialog.show(context, widget.workout, value,
        (newStartDate) {
      if (newStartDate != null && widget.workout.canEdit) {
        widget.workout.updateData(newStartDate: newStartDate);
        FredericBackend.instance.workoutManager
            .updateWorkoutInDB(widget.workout);
      }

      setState(() {
        if (value) {
          FredericBackend.instance.userManager
              .addActiveWorkout(widget.workout.id, newStartDate);
          isSelected = true;
        } else {
          FredericBackend.instance.userManager
              .removeActiveWorkout(widget.workout.id);
          isSelected = false;
        }
        FredericBackend.instance.userManager.userDataChanged();
      });
    });
  }
}
