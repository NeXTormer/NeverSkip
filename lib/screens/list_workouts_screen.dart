import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widgets/workout/add_workout_card.dart';
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
    FredericWorkout demoWorkout =
        FredericWorkout('kKOnczVnBbBHvmx96cjG', shouldLoadActivities: true);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text('Your workouts'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Active workout',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          StreamBuilder<FredericWorkout>(
              stream: demoWorkout.asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) return WorkoutCard(snapshot.data);
                return Container();
              }),
          Divider(height: 0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AddWorkoutCard(null),
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
