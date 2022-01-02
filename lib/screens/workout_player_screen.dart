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

import '../main.dart';

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
  WorkoutPlayerViewType currentView = WorkoutPlayerViewType.Start;

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
                    height: 90,
                    extraSpace: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AnimatedProgressBar(
                        duration: const Duration(milliseconds: 100),
                        progress: playerState.getProgress(),
                        backgroundColor: theme.isColorful ? Colors.white : null,
                        alternateColor: true,
                        length: double.infinity,
                      ),
                    ),
                    subtitle: 'Current workout time and progress',
                    icon: currentView == WorkoutPlayerViewType.Player
                        ? GestureDetector(
                            onTap: () {
                              if (playerState.timerActive) {
                                playerState.pauseTimer();
                              } else {
                                playerState.resumeTimer();
                              }
                            },
                            child: playerState.timerActive
                                ? Icon(Icons.pause,
                                    size: 32,
                                    color: theme.textColorColorfulBackground)
                                : Icon(Icons.play_arrow,
                                    size: 32,
                                    color: theme.textColorColorfulBackground))
                        : null,
                    bottomPadding: 2,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: ,
                  // ),
                ],
              );
            }),
            if (theme.isMonotone) SizedBox(height: 10),
            if (theme.isMonotone) FredericDivider(),
            Flexible(
              child: LayoutBuilder(builder: (context, constraints) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
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
    if (type == WorkoutPlayerViewType.Player) {
      playerState.resumeTimer();
    } else if (type == WorkoutPlayerViewType.End) {
      playerState.pauseTimer();
    }
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
