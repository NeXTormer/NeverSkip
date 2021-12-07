import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_view.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({required this.activities, Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  PageController pageController = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
        body: Container(
      child: Column(
        children: [
          FredericBasicAppBar(
            title: '25:03',
            subtitle: 'Current workout time and progress',
            icon: Icon(Icons.pause),
            bottomPadding: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProgressBar(
              0.4,
              length: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          FredericDivider(),
          Flexible(
            child: LayoutBuilder(builder: (context, constraints) {
              int numberOfActivities = widget.activities.length;
              return PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: numberOfActivities,
                  itemBuilder: (context, index) {
                    return ActivityPlayerView(
                      widget.activities[index],
                      nextActivity: index == (numberOfActivities - 1)
                          ? null
                          : widget.activities[index + 1],
                      constraints: constraints,
                      pageController: pageController,
                    );
                  });
            }),
          ),
        ],
      ),
    ));
  }
}
