import 'package:flutter/material.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/state/page_view_blocker.dart';
import 'package:frederic/state/workout_player_state.dart';
import 'package:frederic/widgets/standard_elements/animated_progress_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_view.dart';
import 'package:frederic/widgets/workout_player_screen/workout_player_start_view.dart';
import 'package:provider/provider.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({required this.activities, Key? key})
      : super(key: key);

  final List<FredericWorkoutActivity> activities;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  PageController pageController = PageController(viewportFraction: 1);
  WorkoutPlayerState playerState = WorkoutPlayerState();
  PageViewBlocker pageViewBlocker = PageViewBlocker();

  @override
  void initState() {
    playerState.setupProgressBar(widget.activities);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkoutPlayerState>.value(
      value: playerState,
      child: ChangeNotifierProvider<PageViewBlocker>.value(
        value: pageViewBlocker,
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
                  int numberOfActivities = widget.activities.length;
                  return Consumer<PageViewBlocker>(
                      builder: (context, blocker, child) {
                    return PageView.builder(

                        ///
                        /// TODO
                        ///
                        /// maybe change physics with blocker
                        /// or maybe impelment custom physics which makes some pages not accessible (probably better option)
                        ///
                        ///
                        //physics: blocker.scrollable : BouncingScrollPhy,
                        controller: pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: numberOfActivities + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return WorkoutPlayerStartView(
                              activities: widget.activities,
                              pageController: pageController,
                              constraints: constraints,
                            );
                          }
                          return ActivityPlayerView(
                            widget.activities[index],
                            nextActivity: index == (numberOfActivities)
                                ? null
                                : widget.activities[index],
                            constraints: constraints,
                            pageController: pageController,
                          );
                        });
                  });
                }),
              ),
            ],
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    playerState.dispose();
    super.dispose();
  }
}
