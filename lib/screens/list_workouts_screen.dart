import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout_builder.dart';
import 'package:frederic/widgets/workout/edit_workout_page.dart';
import 'package:frederic/widgets/workout/workout_card.dart';

class ListWorkoutsScreen extends StatefulWidget {
  static String routeName = '/workouts';

  @override
  _ListWorkoutsScreenState createState() => _ListWorkoutsScreenState();
}

class _ListWorkoutsScreenState extends State<ListWorkoutsScreen> {
  double test = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 108),
          FredericWorkoutBuilder(
              id: 'kKOnczVnBbBHvmx96cjG',
              builder: (context, workout) {
                return WorkoutCard(workout);
              }),
          Divider(height: 0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => EditWorkoutPage(null),
        ),
        //_createWorkoutPrompt,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
