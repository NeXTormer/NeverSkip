import 'package:flutter/material.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widget/second_design/bottonNavBar/bottom_nav_design.dart';
import 'package:frederic/widget/second_design/workout/workout_card.dart';
import 'package:intl/intl.dart';

class WorkoutOverviewScreen extends StatefulWidget {
  static String routeName = '/workouts';

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
      bottomNavigationBar: BottomNavDesign(2),
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
