import 'package:flutter/material.dart';
import 'package:frederic/state/workout_search_term.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
