import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/widgets/home_screen/goal_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_date_picker.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:frederic/widgets/standard_elements/unit_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditGoalDataScreen extends StatefulWidget {
  EditGoalDataScreen(this.goal, {this.sets, this.activity}) {
    isNewGoal = goal.goalID == 'new';
  }
  final FredericGoal goal;

  final FredericSetListData? sets;
  final FredericActivity? activity;

  late final bool isNewGoal;

  @override
  _EditGoalDataScreenState createState() => _EditGoalDataScreenState();
}

class _EditGoalDataScreenState extends State<EditGoalDataScreen> {
  final TextEditingController titleController = TextEditingController();

  final NumberSliderController startStateController = NumberSliderController();
  final NumberSliderController currentStateController =
      NumberSliderController();
  final NumberSliderController endStateController = NumberSliderController();
  final NumberSliderController updateStartSliderController =
      NumberSliderController();
  final NumberSliderController updateEndSliderController =
      NumberSliderController();

  final UnitSliderController unitSliderController = UnitSliderController();

  String dateText = '';
  String dummyActivityID = '';
  String dummyTitle = '';

  num dummyStartState = 0;
  num dummyCurrentState = 0;
  num dummyEndState = 0;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  bool datePickerOpen = false;

  @override
  void initState() {
    dateText = formatDateTime(widget.goal.startDate);
    dummyTitle = widget.goal.title;
    dummyStartState = widget.goal.startState;
    dummyCurrentState = widget.goal.currentState;
    dummyEndState = widget.goal.endState;
    selectedStartDate = widget.goal.startDate;
    selectedEndDate = widget.goal.endDate;

    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: CustomScrollView(
        controller: ModalScrollController.of(context),
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(bottom: 12)),
          buildHeaderRow(),
          SliverDivider(),
          SliverToBoxAdapter(
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GoalCard(
                widget.goal,
                titleController: titleController,
                currentStateController: currentStateController,
                startStateController: startStateController,
                endStateController: endStateController,
                unitSliderController: unitSliderController,
                interactable: false,
              ),
            ),
          ),
          SliverDivider(),
          SliverToBoxAdapter(
            child: Container(
                height: 44,
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FredericButton(
                  '+',
                  onPressed: () => addNewActivityTracker(context),
                  fontSize: 20,
                )),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Title'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FredericTextField(
                widget.goal.title,
                maxLength: 30,
                text: widget.goal.title,
                icon: null,
                controller: titleController,
              ),
            ),
          ),
          // TODO Implement Activity picker
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Goal State'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: kCardBorderColor),
              ),
              child: Column(
                children: [
                  buildSubHeading('Start', Icons.star_outline),
                  SizedBox(height: 12),
                  NumberSlider(
                    constrainController: updateStartSliderController,
                    controller: startStateController,
                    itemWidth: 0.14,
                    numberOfItems: 200,
                    startingIndex: dummyStartState.ceil() + 1,
                  ),
                  SizedBox(height: 12),
                  buildSubHeading('End', Icons.star_outline),
                  SizedBox(height: 12),
                  NumberSlider(
                    constrainController: updateEndSliderController,
                    controller: endStateController,
                    itemWidth: 0.14,
                    numberOfItems: 200,
                    startingIndex: dummyEndState.ceil() + 1,
                  ),
                  SizedBox(height: 12),
                  buildSubHeading('Unit', Icons.alarm),
                  UnitSlider(
                    controller: unitSliderController,
                    itemWidth: 0.15,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Current State'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FredericSlider(
                unit: SliderUnit.Kilograms,
                min: dummyStartState.toDouble(),
                max: dummyEndState.toDouble(),
                value: dummyCurrentState.toDouble(),
                startStateController: startStateController,
                currentStateController: currentStateController,
                endStateController: endStateController,
                isInteractive: true,
                onChanged: (value) {
                  dummyCurrentState = value;
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 42),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // TODO Implement better datepicker
                  buildDatePickerRow('Start Date'),
                  buildDatePickerRow('End Date'),
                ],
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     child: Row(
          //       children: [
          //         Expanded(
          //             flex: 1,
          //             child: FredericButton(
          //               'Delete',
          //               mainColor: Colors.red,
          //               onPressed: () {
          //                 showDialog(
          //                     context: context,
          //                     builder: (ctx) => FredericActionDialog(
          //                           onConfirm: () {
          //                             widget.goal.delete();
          //                             Navigator.of(context).pop();
          //                             Navigator.of(context).pop();
          //                           },
          //                           title: 'Confirm deletion',
          //                           destructiveAction: true,
          //                           child: Text(
          //                               'Do you want to delete your goal? This cannot be undone!',
          //                               textAlign: TextAlign.center),
          //                         ));
          //               },
          //               inverted: true,
          //             )),
          //         SizedBox(width: 16),
          //         Expanded(
          //             flex: 2,
          //             child: FredericButton(
          //                 widget.isNewGoal ? 'Create' : 'Save', onPressed: () {
          //               saveData();
          //               Navigator.of(context).pop();
          //             }))
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  String formatDateTime(DateTime date) {
    String day = date.day.toString();
    if (date.day < 10) day = day.padLeft(2, '0');
    String month = date.month.toString();
    if (date.month < 10) month = month.padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: kTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildDatePickerRow(String text) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            FredericCard(
              width: 100,
              onTap: () {
                setState(() {
                  datePickerOpen = !datePickerOpen;
                });
              },
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  dateText,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        AnimatedContainer(
          height: datePickerOpen ? 150 : 0,
          duration: Duration(microseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: kCardBorderColor),
          ),
          child: FredericDatePicker(initialDate: DateTime.now()),
        ),
      ],
    );
  }

  Widget buildHeaderRow() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(
              ExtraIcons.dumbbell,
              color: kMainColor,
            ),
            SizedBox(width: 32),
            Text(
              widget.isNewGoal ? 'Create Goal' : 'Edit Goal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                saveData();
                Navigator.of(context).pop();
              },
              child: Text(
                widget.isNewGoal ? 'Create' : 'Save',
                style:
                    TextStyle(color: kMainColor, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveData() {
    bool _checkEquality(num first, num second) {
      return first.ceil() != second.ceil();
    }

    bool _checkCompleteness(num value, num target) {
      return value.ceil() == target.ceil();
    }

    Future<void> _showErrorMessage(String text) async {
      await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return Container();
          });
      await showDialog(
          context: context,
          builder: (ctx) {
            return FredericActionDialog(
                title: text,
                infoOnly: true,
                onConfirm: () => Navigator.of(ctx).pop());
          });
    }

    if (widget.isNewGoal) {
      if (_checkEquality(
          startStateController.value, endStateController.value)) {
        if (!_checkCompleteness(
            currentStateController.value, endStateController.value)) {
          widget.goal.save(
            title: titleController.text,
            image:
                'https://media.gq.com/photos/5a3d41215f1f364364dd437a/16:9/w_1280,c_limit/ask-a-trainer-bicep-curl.jpg',
            startState: startStateController.value,
            currentState: currentStateController.value,
            endState: endStateController.value,
            startDate: Timestamp.fromDate(DateTime.now()),
            endDate: Timestamp.fromDate(DateTime.now().add(Duration(days: 2))),
            isComleted: false,
            isDeleted: false,
          );
        } else
          _showErrorMessage('The current state must not match the end state!');
      } else
        _showErrorMessage('The start state must not match the end state!');
    } else {
      // TODO Sinvoller Data check
      if (true) {
        widget.goal.title = titleController.text;
        widget.goal.startState = startStateController.value;
        widget.goal.currentState = currentStateController.value == 0
            ? dummyCurrentState
            : currentStateController.value;
        widget.goal.endState = endStateController.value;
      }
    }
  }

  @override
  void dispose() {
    startStateController.dispose();
    endStateController.dispose();
    currentStateController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void addNewActivityTracker(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (ctx) => BlocProvider.value(
              value: BlocProvider.of<FredericSetManager>(context),
              child: ActivityListScreen(
                isSelector: true,
                onSelect: (activity) {
                  if (widget.isNewGoal) {
                    dummyActivityID = activity.activityID;
                    titleController.text = activity.name;
                  } else {
                    int value = widget.sets![activity.activityID].bestWeight;
                    dummyActivityID = activity.activityID;
                    titleController.text = activity.name;
                    if (dummyStartState < dummyEndState) {
                      if (currentStateController.value > dummyEndState) {
                        updateEndSliderController.value = value;
                        endStateController.value = value;
                      } else if (currentStateController.value <
                          startStateController.value) {
                        startStateController.value = value;
                        updateStartSliderController.value = value;
                      }
                    } else {
                      if (currentStateController.value > dummyStartState) {
                        startStateController.value = value;
                        updateEndSliderController.value = value;
                      } else if (currentStateController.value < dummyEndState) {
                        endStateController.value = value;
                        updateStartSliderController.value = value;
                      }
                    }
                    currentStateController.value = value;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ));
  }
}
