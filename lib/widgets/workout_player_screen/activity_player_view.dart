import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/state/workout_player_state.dart';
import 'package:frederic/widgets/add_progress_screen/add_progress_card.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_activity_card.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_set_segment.dart';
import 'package:provider/provider.dart';

class ActivityPlayerView extends StatefulWidget {
  const ActivityPlayerView(this.activity,
      {required this.pageController,
      required this.constraints,
      this.nextActivity,
      this.showSmartSuggestions = true,
      Key? key})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final FredericWorkoutActivity? nextActivity;

  final bool showSmartSuggestions;

  final BoxConstraints constraints;
  final PageController pageController;

  @override
  State<ActivityPlayerView> createState() => _ActivityPlayerViewState();
}

class _ActivityPlayerViewState extends State<ActivityPlayerView> {
  AddProgressController addProgressController = AddProgressController(10, 50);
  ScrollController scrollController = ScrollController();

  List<RepsWeightSuggestion> suggestions = <RepsWeightSuggestion>[];

  BooleanChangeNotifier finished = BooleanChangeNotifier();

  @override
  void initState() {
    super.initState();
  }

  void preparePlayer() {
    // set total
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericSetManager, FredericSetListData>(
        buildWhen: (current, next) =>
            next.changedActivities.contains(widget.activity.activity.id),
        builder: (context, setListData) {
          return Container(
            height: widget.constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ChangeNotifierProvider<BooleanChangeNotifier>.value(
                value: finished,
                child: Column(
                  children: [
                    Consumer<BooleanChangeNotifier>(
                      builder: (context, finished, child) =>
                          ActivityPlayerActivityCard(
                        widget.activity,
                        disabled: false,
                        finished: finished.value,
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                        child: ActivityPlayerSetSegment(
                      widget.activity,
                      controller: scrollController,
                    )),
                    SizedBox(height: 16),
                    Consumer<WorkoutPlayerState>(
                        builder: (context, playerState, child) {
                      return AddProgressCard(
                          controller: addProgressController,
                          activity: widget.activity.activity,
                          onSave: () => saveProgress(playerState),
                          suggestions: widget.showSmartSuggestions
                              ? setListData[widget.activity.activity.id]
                                  .getSuggestions(
                                      weighted: widget.activity.activity.type ==
                                          FredericActivityType.Weighted,
                                      recommendedReps: widget.activity.reps)
                              : null);
                    }),
                    SizedBox(height: 16),
                    Consumer<BooleanChangeNotifier>(
                        builder: (context, finished, child) {
                      return ActivityPlayerActivityCard(
                        widget.nextActivity,
                        finished: false,
                        disabled: !finished.value,
                        onTap: () {
                          if (widget.nextActivity == null) {
                          } else {
                            widget.pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void saveProgress(WorkoutPlayerState playerState) {
    int reps = addProgressController.reps;
    double weight = addProgressController.weight;
    FredericSet set = FredericSet(reps, weight, DateTime.now());
    playerState.addProgress(widget.activity.activity, set);
    FredericBackend.instance.setManager
        .addSet(widget.activity.activity.id, set);

    FredericBackend.instance.analytics.logAddProgressOnWorkoutPlayer();
  }
}

class BooleanChangeNotifier extends ChangeNotifier {
  BooleanChangeNotifier();
  bool _value = false;

  bool get value => _value;
  set value(bool v) {
    _value = v;
    notifyListeners();
  }
}
