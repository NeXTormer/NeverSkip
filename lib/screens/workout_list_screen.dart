import 'package:flutter/material.dart';
import 'package:frederic/state/workout_search_term.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ChangeNotifierProvider<WorkoutSearchTerm>(
          create: (context) => searchTerm,
          child: CustomScrollView(
            slivers: [
              WorkoutListAppbar(searchTerm),
              SliverDivider(),
              WorkoutListSegment(),
            ],
          ),
        ),
      ),
    );
  }
}
