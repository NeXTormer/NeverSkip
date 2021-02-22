import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widgets/workout/workout_prompt.dart';
import 'package:frederic/widgets/workout/workout_card.dart';

class ListWorkoutsScreen extends StatefulWidget {
  static String routeName = '/workouts';

  @override
  _ListWorkoutsScreenState createState() => _ListWorkoutsScreenState();
}

class _ListWorkoutsScreenState extends State<ListWorkoutsScreen> {
  double _durationWeeks = 1;
  double test = 1;
  double _weeks = 1;

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
        onPressed: _createWorkoutPrompt,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  void _createWorkoutPrompt() async {
    final selectedDurationWeeks = await showDialog<double>(
      context: context,
      builder: (context) => WorkoutPrompt(_durationWeeks),
    );

    if (_durationWeeks != null) {
      setState(() {
        _durationWeeks = selectedDurationWeeks;
      });
    }
  }
}
