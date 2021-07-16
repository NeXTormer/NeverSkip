import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/state/workout_search_term.dart';
import 'package:frederic/widgets/workout_list_screen/workout_card.dart';
import 'package:provider/provider.dart';

class WorkoutListSegment extends StatelessWidget {
  const WorkoutListSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericWorkoutManager, FredericWorkoutListData>(
        builder: (context, workoutList) {
      return BlocBuilder<FredericUserManager, FredericUser>(
          builder: (context, user) {
        return Consumer<WorkoutSearchTerm>(
            builder: (context, searchTerm, child) {
          List<FredericWorkout> workouts = workoutList.workouts.values
              .where((element) => element.name.contains(searchTerm.searchTerm))
              .toList();
          print('===consume');
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutCard(workouts[index]),
            );
          }, childCount: workouts.length));
        });
      });
    });
  }
}
