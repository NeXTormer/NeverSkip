import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/edit_goal_data_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card_medaille_indicator.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_finish_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/number_wheel.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';
import 'package:frederic/widgets/standard_elements/unit_slider.dart';

class NormalGoalCard extends StatefulWidget {
  const NormalGoalCard(this.goal,
      {this.sets,
      this.activity,
      this.startDate,
      this.endDate,
      this.titleController,
      this.startStateController,
      this.currentStateController,
      this.endStateController,
      this.unitSliderController,
      this.interactable = true});

  final FredericGoal goal;

  final FredericSetListData? sets;
  final FredericActivity? activity;

  final DateTime? startDate;
  final DateTime? endDate;

  final TextEditingController? titleController;

  final NumberSliderController? startStateController;
  final NumberSliderController? currentStateController;
  final NumberSliderController? endStateController;

  final UnitSliderController? unitSliderController;

  final bool interactable;

  @override
  _NormalGoalCard createState() => _NormalGoalCard();
}

class _NormalGoalCard extends State<NormalGoalCard> {
  String? title;
  String unit = '';

  num? startState;
  num? currentState;
  num? endState;
  bool inverse = false;
  bool isCompleted = false;

  @override
  void initState() {
    unit = widget.goal.unit;
    if (widget.startStateController != null &&
        widget.startStateController != null &&
        widget.currentStateController != null &&
        widget.endStateController != null) {
      widget.unitSliderController!.addListener(() {
        setState(() {
          unit = widget.unitSliderController!.value;
        });
      });
      widget.startStateController!.addListener(() {
        setState(() {
          startState = widget.startStateController!.value;
        });
      });
      widget.endStateController!.addListener(() {
        setState(() {
          endState = widget.endStateController!.value;
          if (widget.endStateController!.value <=
              widget.startStateController!.value)
            inverse = true;
          else
            inverse = false;
        });
      });
      widget.currentStateController!.addListener(() {
        setState(() {
          currentState = widget.currentStateController!.value;
        });
      });
      widget.titleController!.addListener(() {
        setState(() {
          title = widget.titleController!.text;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sets != null && widget.goal.activityID != '') {
      currentState = widget.sets![widget.goal.activityID].bestWeight == 0
          ? widget.sets![widget.goal.activityID].bestReps
          : widget.sets![widget.goal.activityID].bestWeight;
    }
    double currentStateNormalized = normalizeValue(
        (currentState ?? widget.goal.currentState),
        (startState ?? widget.goal.startState),
        (endState ?? widget.goal.endState));
    isCompleted = false;
    if (mounted && widget.interactable) checkIfGoalIsCompleted();

    return Stack(
      fit: widget.interactable ? StackFit.loose : StackFit.expand,
      children: [
        FredericCard(
          shimmer: isCompleted ? true : false,
          onLongPress: () {
            if (widget.interactable) handleLongClick(context);
          },
          onTap: () {
            if (widget.interactable) handleClick();
          },
          width: 260,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              PictureIcon(
                  widget.activity == null
                      ? widget.goal.image
                      : widget.activity!.image,
                  mainColor: theme.mainColorInText),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${title ?? widget.goal.title}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.greyTextColor, fontSize: 12),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: FredericChip(
                                '${widget.goal.endDate.difference(widget.goal.startDate).inDays} days'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: buildProgressBarText(
                                      startState ?? widget.goal.startState,
                                      '${widget.interactable ? widget.goal.unit : unit}'),
                                ),
                                Flexible(
                                  child: buildProgressBarText(
                                      endState ?? widget.goal.endState,
                                      '${widget.interactable ? widget.goal.unit : unit}'),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ProgressBar(
                                  inverse
                                      ? (inverseValue(
                                          widget.currentStateController!.value
                                              .toDouble(),
                                          widget.endStateController!.value
                                              .toDouble(),
                                          widget.startStateController!.value
                                              .toDouble()))
                                      : currentStateNormalized.toDouble(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        if (isCompleted)
          Positioned(
            top: -2,
            left: 22,
            child: Container(
              child: GoalCardMedailleIndicator(),
            ),
          ),
      ],
    );
  }

  double inverseValue(double value, double start, double end,
      {bool normalized = true}) {
    if ((end - start) == 0) return start;
    double startEndDifference = (end - start).abs();
    double inverseTrueCurrentValue =
        start + startEndDifference * (1 - normalizeValue(value, start, end));

    if (normalized)
      return normalizeValue(inverseTrueCurrentValue, start, end);
    else
      return inverseTrueCurrentValue;
  }

  double normalizeValue(num value, num start, num end) {
    if ((end - start) == 0) return 0;
    return (value - start) / (end - start);
  }

  Widget buildProgressBarText(var text, String unit) {
    return RichText(
      text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '$text',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: theme.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            TextSpan(text: ' '),
            TextSpan(
                text: '$unit',
                style: TextStyle(
                  color: theme.textColor,
                ))
          ]),
    );
  }

  void handleClick() {
    isCompleted
        ? showModal(
            configuration: FadeScaleTransitionConfiguration(
              transitionDuration: Duration(milliseconds: 500),
            ),
            context: context,
            builder: (ctx) {
              HapticFeedback.heavyImpact();
              return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(10),
                  child: GoalFinishActionDialog(widget.goal));
            },
          )
        : showFredericBottomSheet(
            context: context,
            builder: (c) => Scaffold(
                    body: EditGoalDataScreen(
                  widget.goal,
                  sets: widget.sets,
                  activity: widget.activity,
                )));
  }

  void handleLongClick(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => FredericActionDialog(
              onConfirm: () {
                var goalscount =
                    FredericBackend.instance.userManager.state.goalsCount;
                if (goalscount >= 1)
                  FredericBackend.instance.userManager.state.goalsCount -= 1;
                FredericBackend.instance.goalManager
                    .add(FredericGoalDeleteEvent(widget.goal));
                Navigator.of(context).pop();
              },
              destructiveAction: true,
              title: 'Confirm deletion',
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                    "Do you want to delete your personal goal? '${widget.goal.title}' This cannot be undone!",
                    textAlign: TextAlign.center),
              ),
            ));
  }

  void checkIfGoalIsCompleted() {
    double state = normalizeValue(
        (currentState ?? widget.goal.currentState),
        (startState ?? widget.goal.startState),
        (endState ?? widget.goal.endState));
    if (state >= 1) {
      isCompleted = true;
    }
  }
}
