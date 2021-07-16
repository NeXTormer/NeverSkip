import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/edit_workout_data_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

///
/// Part of the EditWorkoutScreen. Responsible for displaying
/// the top bar of information.
///
class EditWorkoutHeader extends StatelessWidget {
  EditWorkoutHeader(this.workout);

  final FredericWorkout workout;

  @override
  Widget build(BuildContext context) {
    final String dateFormatString =
        formatDate(workout.startDate, const [dd, ' ', M, ' ', yyyy]);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$dateFormatString',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF272727),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.6,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${workout.name}',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 8),
                child: InkWell(
                  onTap: () => CupertinoScaffold.showCupertinoModalBottomSheet(
                      context: context,
                      builder: (c) => EditWorkoutDataScreen(workout)),
                  child: Icon(
                    ExtraIcons.settings,
                    color: kMainColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
