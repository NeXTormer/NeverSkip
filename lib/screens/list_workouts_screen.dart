import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/second_design/workout/workout_card.dart';

class ListWorkoutsScreen extends StatefulWidget {
  static String routeName = '/workouts';

  @override
  _ListWorkoutsScreenState createState() => _ListWorkoutsScreenState();
}

class _ListWorkoutsScreenState extends State<ListWorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    FredericWorkout demoWorkout = FredericWorkout('kKOnczVnBbBHvmx96cjG');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
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
          FutureBuilder<FredericWorkout>(
              future: demoWorkout.loadData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) return WorkoutCard(snapshot.data);
                return Container();
              }),
          Divider(height: 0),
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
