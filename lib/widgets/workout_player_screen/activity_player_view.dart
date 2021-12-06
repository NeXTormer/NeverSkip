import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/widgets/add_progress_screen/add_progress_card.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_activity_card.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_set_segment.dart';

class ActivityPlayerView extends StatefulWidget {
  const ActivityPlayerView(this.activity, {required this.constraints, Key? key})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final BoxConstraints constraints;

  @override
  State<ActivityPlayerView> createState() => _ActivityPlayerViewState();
}

class _ActivityPlayerViewState extends State<ActivityPlayerView> {
  AddProgressController addProgressController = AddProgressController(10, 50);
  List<RepsWeightSuggestion> suggestions = <RepsWeightSuggestion>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericSetManager, FredericSetListData>(
        builder: (context, setListData) {
      return Container(
        height: widget.constraints.maxHeight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ActivityPlayerActivityCard(
                widget.activity,
                indicator: true,
              ),
              SizedBox(height: 8),
              Expanded(
                  child: ActivityPlayerSetSegment(
                widget.activity,
                setListData: setListData,
              )),
              SizedBox(height: 16),
              AddProgressCard(
                  controller: addProgressController,
                  activity: widget.activity.activity,
                  onSave: () {},
                  suggestions: suggestions),
              SizedBox(height: 16),
              ActivityPlayerActivityCard(
                widget.activity,
                indicator: true,
                disabled: true,
              ),
            ],
          ),
        ),
      );
    });
  }
}
