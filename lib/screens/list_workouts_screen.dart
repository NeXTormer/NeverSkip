import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout_builder.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/workout_list_screen/edit_workout_page.dart';
import 'package:frederic/widgets/workout_list_screen/workout_card.dart';

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
        children: [
          Expanded(
            child: FredericWorkoutBuilder(builder: (context, list) {
              List<FredericWorkout?> workouts = list;
              return ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  return WorkoutCard(workouts[index]!);
                },
                itemCount: workouts?.length ?? 0,
              );
            }),
          ),
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
        backgroundColor: kMainColor,
        splashColor: kAccentColor,
        child: Icon(Icons.add, size: 36),
      ),
    );
  }
}
