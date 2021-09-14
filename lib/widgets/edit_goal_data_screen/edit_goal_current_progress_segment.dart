import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';

class EditGoalCurrentProgressSegment extends StatefulWidget {
  const EditGoalCurrentProgressSegment(
      {this.startStateController,
      this.currentStateController,
      this.endStateController,
      this.dummyStartState,
      this.dummyCurrentState,
      this.dummyEndState,
      this.sets,
      this.activity,
      this.trackActivity});

  final NumberSliderController? startStateController;
  final NumberSliderController? currentStateController;
  final NumberSliderController? endStateController;

  final num? dummyStartState;
  final num? dummyCurrentState;
  final num? dummyEndState;

  final FredericSetListData? sets;
  final FredericActivity? activity;

  final bool trackActivity;

  @override
  _EditGoalCurrentProgressSegmentState createState() =>
      _EditGoalCurrentProgressSegmentState();
}

class _EditGoalCurrentProgressSegmentState
    extends State<EditGoalCurrentProgressSegment> {
  num dummyCurrentState = 0;
  @override
  Widget build(BuildContext context) {
    return widget.trackActivity
        ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProgressIndicatorCard(
                  widget.sets![widget.activity!.activityID], widget.activity),
            ),
          )
        : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FredericSlider(
                unit: SliderUnit.Kilograms,
                min: widget.dummyStartState.toDouble(),
                max: widget.dummyEndState.toDouble(),
                value: widget.dummyCurrentState.toDouble(),
                startStateController: widget.startStateController,
                currentStateController: widget.currentStateController,
                endStateController: widget.endStateController,
                isInteractive: true,
                onChanged: (value) {
                  dummyCurrentState = value;
                },
              ),
            ),
          );
  }
}
