import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_data_screen.dart';
import 'package:frederic/state/workout_search_term.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:frederic/widgets/workout_list_screen/workout_list_appbar.dart';
import 'package:frederic/widgets/workout_list_screen/workout_list_segment.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      floatingActionButton: buildAddExerciseButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: ChangeNotifierProvider<WorkoutSearchTerm>(
          create: (context) => searchTerm,
          child: CustomScrollView(
            slivers: [
              WorkoutListAppbar(searchTerm),
              SliverDivider(),
              SliverToBoxAdapter(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FredericHeading('Active'),
              )),
              WorkoutListSegment(true),
              SliverToBoxAdapter(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FredericHeading('Other'),
              )),
              WorkoutListSegment(false),
              SliverToBoxAdapter(child: Container(height: 100))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddExerciseButton(BuildContext context) {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: kMainColor,
        onPressed: () => CupertinoScaffold.showCupertinoModalBottomSheet(
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
