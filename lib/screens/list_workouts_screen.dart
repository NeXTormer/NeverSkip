import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/second_design/workout/workout_card.dart';

class WorkoutOverviewScreen extends StatefulWidget {
  WorkoutOverviewScreen(this.workout);

  static String routeName = '/workouts';

  final FredericWorkout workout;

  @override
  _WorkoutOverviewScreenState createState() => _WorkoutOverviewScreenState();
}

class _WorkoutOverviewScreenState extends State<WorkoutOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('Your Workouts'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Active Workout',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          WorkoutCard(),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, EditWorkoutScreen.routeName);
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
