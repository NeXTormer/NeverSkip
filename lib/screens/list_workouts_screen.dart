import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widgets/workout/add_workout_card.dart';
import 'package:frederic/backend/frederic_workout_builder.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
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
          if (false)
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Active workout',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
          FredericWorkoutBuilder(
              id: 'kKOnczVnBbBHvmx96cjG',
              builder: (context, list) {
                return WorkoutCard(list);
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
