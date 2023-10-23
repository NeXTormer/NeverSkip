import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/edit_workout_data_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';

///
/// Part of the EditWorkoutScreen. Responsible for displaying
/// the top bar of information.
///
class EditWorkoutHeader extends StatelessWidget {
  EditWorkoutHeader(this.workout);

  final FredericWorkout workout;

  @override
  Widget build(BuildContext context) {
    DateTime? startDate;
    if (workout.canEdit) {
      startDate = workout.startDate;
    } else {
      final user = FredericBackend.instance.userManager.state;
      startDate = user.activeWorkouts[workout.id];
    }

    String? dateFormatString;

    if (startDate != null) {
      dateFormatString = formatDate(startDate, const [dd, ' ', M, ' ', yyyy]);
    } else {
      dateFormatString = tr('workouts.not_started');
    }
    return FredericBasicAppBar(
        title: workout.name,
        //height: 75,
        bottomPadding: theme.isColorful ? 8 : 2,
        topPadding: 16,
        backButton: true,
        subtitle: '${tr("misc.start_day")}: $dateFormatString',
        icon: workout.canEdit
            ? InkWell(
                onTap: () => showFredericBottomSheet(
                    context: context,
                    builder: (c) =>
                        Scaffold(body: EditWorkoutDataScreen(workout))),
                child: Icon(
                  ExtraIcons.settings,
                  color: theme.isColorful ? Colors.white : theme.mainColor,
                ),
              )
            : null);
  }
}
