import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/screens/workout_player_screen.dart';
import 'package:frederic/widgets/calendar_screen/calendar_day.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class WorkoutPlayerStartView extends StatelessWidget {
  const WorkoutPlayerStartView(
      {required this.activities,
      required this.constraints,
      required this.changeView,
      Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;
  final BoxConstraints constraints;
  final void Function(WorkoutPlayerViewType) changeView;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FredericHeading('Workout Overview'),
          SizedBox(height: 16),
          Expanded(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return CalendarActivityCard(
                activities[index],
                onTap: () {},
              );
            },
          )),
          SizedBox(height: 24),
          FredericButton(
            'Lets go!',
            onPressed: () {
              changeView(WorkoutPlayerViewType.Player);
            },
            fontSize: 18,
          ),
        ],
      ),
    ));
  }
}
