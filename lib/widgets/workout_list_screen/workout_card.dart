import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard(this.workout,
      {Key? key, this.name, this.description, this.period, this.repeating})
      : clickable = true,
        super(key: key);

  const WorkoutCard.dummy(this.workout,
      {this.name, this.description, this.period, this.repeating})
      : clickable = false;

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
        .contains(widget.workout.workoutID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isRepeating = widget.repeating ?? widget.workout.repeating;
    return FredericCard(
        height: 114,
        onTap: widget.clickable
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CupertinoScaffold(
                        body: EditWorkoutScreen(widget.workout.workoutID))));
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
                    child: PictureIcon(widget.workout.image),
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
                                padding: const EdgeInsets.only(top: 4),
                                child: Transform.scale(
                                  scale: 0.88,
                                  child: CupertinoSwitch(
                                    key: ValueKey(widget.workout.workoutID),
                                    value: isSelected,
                                    activeColor: theme.mainColor,
                                    onChanged: widget.workout.workoutID == 'new'
                                        ? null
                                        : (value) =>
                                            handleSwitch(context, value),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FredericChip(
                              '${widget.period ?? widget.workout.period} week${(widget.period ?? widget.workout.period) == 1 ? '' : 's'}',
                              fontSize: 12,
                            ),
                            SizedBox(width: 10),
                            if (isRepeating)
                              FredericChip(
                                'repeating',
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

  void handleSwitch(BuildContext context, bool value) {
    String action = value ? 'Enable' : 'Disable';
    FredericActionDialog.show(
        context: context,
        dialog: FredericActionDialog(
          actionText: action,
          title: 'Change active status',
          closeOnConfirm: true,
          childText: 'Do you want to ${action.toLowerCase()} the workout?',
          onConfirm: () => setState(() {
            List<String> activeWorkouts =
                FredericBackend.instance.userManager.state.activeWorkouts;
            if (value) {
              if (!activeWorkouts.contains(widget.workout.workoutID)) {
                activeWorkouts.add(widget.workout.workoutID);
              }
              isSelected = true;
            } else {
              if (activeWorkouts.contains(widget.workout.workoutID)) {
                activeWorkouts.remove(widget.workout.workoutID);
              }
              isSelected = false;
            }
            FredericBackend.instance.userManager.state.activeWorkouts =
                activeWorkouts;
          }),
        ));
  }
}
