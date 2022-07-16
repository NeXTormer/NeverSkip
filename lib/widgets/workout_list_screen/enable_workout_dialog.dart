import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_date_picker.dart';

class EnableDisableWorkoutDialog extends StatefulWidget {
  const EnableDisableWorkoutDialog(
      {required this.workout,
      required this.enabling,
      required this.onSelect,
      Key? key})
      : super(key: key);

  final FredericWorkout workout;
  final bool enabling;
  final void Function(DateTime?) onSelect;

  static Future<void> show(BuildContext context, FredericWorkout workout,
      bool enabling, void Function(DateTime?) onSelect) {
    return showDialog(
        context: context,
        builder: (c) => EnableDisableWorkoutDialog(
              workout: workout,
              enabling: enabling,
              onSelect: onSelect,
            ));
  }

  @override
  State<EnableDisableWorkoutDialog> createState() =>
      _EnableDisableWorkoutDialogState();
}

class _EnableDisableWorkoutDialogState
    extends State<EnableDisableWorkoutDialog> {
  DateTime? newWorkoutStartDate;

  @override
  Widget build(BuildContext context) {
    String action = widget.enabling ? 'Enable' : 'Disable';

    return FredericActionDialog(
      actionText: action,
      title: '$action the workout?',
      closeOnConfirm: true,
      childText: widget.enabling
          ? null
          : 'Do you want to ${action.toLowerCase()} the workout?',
      child: !widget.enabling
          ? null
          : Column(
              children: [
                Text("You can select another starting date if you want."),
                const SizedBox(height: 16),
                FredericDatePicker(
                  onDateChanged: (date) {
                    newWorkoutStartDate = date;
                  },
                  initialDate: widget.workout.startDate,
                ),
                const SizedBox(height: 8),
              ],
            ),
      onConfirm: () => widget.onSelect.call(newWorkoutStartDate),
    );
  }
}
