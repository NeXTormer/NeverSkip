import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widgets/calendar_screen/calendar_activity_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarWorkoutWidget extends StatelessWidget {
  const CalendarWorkoutWidget({Key key, @required this.workout}) : super(key: key);

  final FredericWorkout workout;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                    child: Text(
                      workout.name,
                      style: GoogleFonts.varelaRound(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(workout.image, scale: 1),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            workout.description,
                            style: TextStyle(fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
