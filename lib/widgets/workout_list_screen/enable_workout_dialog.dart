import 'package:easy_localization/easy_localization.dart';
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
    String action = widget.enabling ? tr('enable') : tr('disable');

    return FredericActionDialog(
      actionText: action,
      title: tr('workouts.action_the_workout', args: [action]),
      closeOnConfirm: true,
      childText: widget.enabling
          ? null
          : tr('workouts.action_the_workout_long',
              args: [action.toLowerCase()]),
      child: !widget.enabling
          ? null
          : Column(
              children: [
                Text('workouts.select_another_startdate').tr(),
                const SizedBox(height: 16),
                FredericDatePicker(
                  showBorder: false,
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
