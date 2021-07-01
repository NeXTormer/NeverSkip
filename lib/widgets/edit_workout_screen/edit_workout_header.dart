import 'package:flutter/material.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:google_fonts/google_fonts.dart';

///
/// Part of the EditWorkoutScreen. Responsible for displaying
/// the top bar of information.
///
class EditWorkoutHeader extends StatelessWidget {
  const EditWorkoutHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                        'July 01, 2021',
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
                        'Today',
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
              Icon(
                ExtraIcons.bell_1,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
