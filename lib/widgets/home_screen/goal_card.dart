import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/screens/edit_goal_data_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';
import 'package:frederic/widgets/standard_elements/unit_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GoalCard extends StatefulWidget {
  const GoalCard(this.goal,
      {this.startDate,
      this.endDate,
      this.titleController,
      this.startStateController,
      this.currentStateController,
      this.endStateController,
      this.unitSliderController,
      this.interactable = true});

  final FredericGoal goal;

  final DateTime? startDate;
  final DateTime? endDate;

  final TextEditingController? titleController;

  final NumberSliderController? startStateController;
  final NumberSliderController? currentStateController;
  final NumberSliderController? endStateController;

  final UnitSliderController? unitSliderController;

  final bool interactable;

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  String? title;
  String? unit;

  num? startState;
  num? currentState;
  num? endState;
  bool inverse = false;

  @override
  void initState() {
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
          if (widget.endStateController!.value <=
              widget.startStateController!.value)
            inverse = true;
          else
            inverse = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double currentStateNormalized = normalizeValue(
        (currentState ?? widget.goal.currentState),
        (startState ?? widget.goal.startState),
        (endState ?? widget.goal.endState));
    return FredericCard(
      onLongPress: () {
        if (widget.interactable) handleLongClick(context);
      },
      onTap: () {
        if (widget.interactable) handleClick(context);
      },
      width: 260,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          PictureIcon(widget.goal.image),
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
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 10),
                          text: TextSpan(
                            text: '${title ?? widget.goal.title}',
                            style: const TextStyle(
                                color: const Color(0x7A3A3A3A),
                                fontSize: 10,
                                letterSpacing: 0.3),
                          ),
                        ),
                      ),
                      Flexible(
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
                                  '${unit ?? "kg"}'),
                            ),
                            Flexible(
                              child: buildProgressBarText(
                                  endState ?? widget.goal.endState,
                                  '${unit ?? "kg"}'),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            TextSpan(text: ' '),
            TextSpan(text: '$unit')
          ]),
    );
  }

  void handleClick(BuildContext context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (c) => Scaffold(body: EditGoalDataScreen(widget.goal)));
  }

  void handleLongClick(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => FredericActionDialog(
              onConfirm: () {
                // FredericBackend.instance.goalManager.deleteGoal(widget.goal);
                widget.goal.delete();
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
}
