import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/edit_workout_data_screen.dart';
import 'package:frederic/state/workout_search_term.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/workout_list_screen/workout_list_appbar.dart';
import 'package:frederic/widgets/workout_list_screen/workout_list_segment.dart';
import 'package:provider/provider.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  WorkoutSearchTerm searchTerm = WorkoutSearchTerm();

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      floatingActionButton: buildAlternativeAddWorkoutButton(context),
      body: ChangeNotifierProvider<WorkoutSearchTerm>(
        create: (context) => searchTerm,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            BlocBuilder<FredericUserManager, FredericUser>(
                builder: (context, user) =>
                    WorkoutListAppbar(searchTerm, user: user)),
            SliverPadding(padding: const EdgeInsets.only(top: 8)),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading.translate('workouts.enabled'),
            )),
            WorkoutListSegment(true),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading.translate('workouts.disabled'),
            )),
            WorkoutListSegment(false),
            SliverToBoxAdapter(child: Container(height: 100))
          ],
        ),
      ),
    );
  }

  Widget buildAlternativeAddWorkoutButton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: theme.mainColor,
        heroTag: 'fab_workoutlistscreen',
        onPressed: () => showFredericBottomSheet(
            context: context,
            builder: (c) => Scaffold(
                body: EditWorkoutDataScreen(FredericWorkout.create()))),
        child: Icon(
          Icons.add_chart,
          color: Colors.white,
        ));
  }

  Widget buildAddWorkoutButton(BuildContext context) {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'fab_workoutlistscreen',
        highlightElevation: 0,
        backgroundColor: theme.mainColor,
        onPressed: () => showFredericBottomSheet(
            context: context,
            builder: (c) => Scaffold(
                body: EditWorkoutDataScreen(FredericWorkout.create()))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Text(
          'Add workout plan',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
