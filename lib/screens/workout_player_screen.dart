import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/state/workout_player_state.dart';
import 'package:frederic/widgets/standard_elements/animated_progress_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/workout_player_screen/workout_player_end_view.dart';
import 'package:frederic/widgets/workout_player_screen/workout_player_start_view.dart';
import 'package:frederic/widgets/workout_player_screen/workout_player_view.dart';
import 'package:provider/provider.dart';

enum WorkoutPlayerViewType { Start, End, Player }

class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({required this.activities, Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  WorkoutPlayerState playerState = WorkoutPlayerState();
  WorkoutPlayerViewType currentView = WorkoutPlayerViewType.Player;

  @override
  void initState() {
    playerState.setupProgressBar(widget.activities);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkoutPlayerState>.value(
      value: playerState,
      child: FredericScaffold(
          body: Container(
        child: Column(
          children: [
            Consumer<WorkoutPlayerState>(
                builder: (context, playerState, child) {
              return Column(
                children: [
                  FredericBasicAppBar(
                    title: playerState.getCurrentTime(),
                    subtitle: 'Current workout time and progress',
                    icon: Icon(Icons.pause),
                    bottomPadding: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AnimatedProgressBar(
                      duration: const Duration(milliseconds: 100),
                      progress: playerState.getProgress(),
                      length: double.infinity,
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 10),
            FredericDivider(),
            Flexible(
              child: LayoutBuilder(builder: (context, constraints) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: currentView == WorkoutPlayerViewType.Player
                      ? WorkoutPlayerView(
                          changeView: changeView,
                          constraints: constraints,
                          activities: widget.activities)
                      : currentView == WorkoutPlayerViewType.Start
                          ? WorkoutPlayerStartView(
                              activities: widget.activities,
                              changeView: changeView,
                              constraints: constraints)
                          : WorkoutPlayerEndView(
                              activities: widget.activities,
                              constraints: constraints),
                );
              }),
            ),
          ],
        ),
      )),
    );
  }

  void changeView(WorkoutPlayerViewType type) {
    setState(() {
      currentView = type;
    });
  }

  @override
  void dispose() {
    playerState.dispose();
    super.dispose();
  }
}
