import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/extensions.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/screens.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_date_picker.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card.dart';
import 'package:frederic/widgets/standard_elements/number_wheel.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:frederic/widgets/standard_elements/unit_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum Datepicker { Start, End }

enum FormError {
  CurrentStateEqualsEndStart,
  StartStateEqualsEndState,
  EndDateSmallerThenStartDate,
  StartDateEqualsEndDate,
  Success,
}

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

  final UnitSliderController unitSliderController = UnitSliderController();

  PageController? endPageController;

  String startDateText = '';
  String endDateText = '';

  num dummyCurrentState = 0;
  FredericActivity? dummyActivity;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  bool startDatepickerOpened = false;
  bool endDatepickerOpened = false;
  bool trackActivity = false;

  @override
  void initState() {
    startDateText = formatDateTime(widget.goal.startDate);
    endDateText = widget.isNewGoal
        ? DateTime.now().add(Duration(days: 7)).formattedEuropean()
        : formatDateTime(widget.goal.endDate);
    titleController.text = widget.goal.title;
    startStateController.value = widget.goal.startState;
    currentStateController.value = widget.goal.currentState;
    endStateController.value = widget.goal.endState;
    unitSliderController.value = widget.goal.unit;
    selectedStartDate = widget.goal.startDate;
    selectedEndDate = widget.isNewGoal
        ? DateTime.now().add(Duration(days: 7))
        : widget.goal.endDate;
    dummyCurrentState = widget.goal.currentState;

    if (widget.goal.activityID != '') {
      trackActivity = true;
      dummyActivity = widget.activity;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: CustomScrollView(
        controller: ModalScrollController.of(context),
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(bottom: 12)),
          buildHeaderSegment(),
          SliverDivider(),
          buildGoalCard(),
          SliverDivider(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Title'),
            ),
          ),
          buildTitleSegment(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Goal State'),
            ),
          ),
          buildGoalStateSegment(),
          buildCurrentStateHeadingAndLinkActivity(),
          buildCurrentStateSegment(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 42),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  buildDatePickerRow('Start Date', Datepicker.Start,
                      initialDate: DateTime.now()),
                  buildDatePickerRow(
                    'End Date',
                    Datepicker.End,
                    initialDate: DateTime.now().add(
                      Duration(days: 7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: FredericButton(
                          widget.isNewGoal ? 'Create' : 'Save', onPressed: () {
                        saveData();
                        Navigator.of(context).pop();
                      })),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

// enum FormError {
//   CurrentStateEqualsEndStart,
//   StartStateEqualsEndState,
//   EndDateSmallerThenStartDate,
//   StartDateEqualsEndDate
// }
  void saveData() {
    FormError _checkForm() {
      if (startStateController.value == endStateController.value) {
        return FormError.StartStateEqualsEndState;
      } else if (currentStateController.value == endStateController.value) {
        return FormError.CurrentStateEqualsEndStart;
      } else if (startDateText == endDateText) {
        return FormError.StartDateEqualsEndDate;
      } else if (selectedStartDate!.compareTo(selectedEndDate!) > 0) {
        return FormError.EndDateSmallerThenStartDate;
      }
      return FormError.Success;
    }

    Future<void> _showErrorMessage(String text) async {
      await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return Container();
        },
      );
      await showDialog(
        context: context,
        builder: (ctx) {
          return FredericActionDialog(
              title: text,
              infoOnly: true,
              onConfirm: () => Navigator.of(ctx).pop());
        },
      );
    }

    if (widget.isNewGoal) {
      switch (_checkForm()) {
        case FormError.CurrentStateEqualsEndStart:
          _showErrorMessage('The curret state must not match the end state!');
          return;
        case FormError.StartStateEqualsEndState:
          _showErrorMessage('The start state must not match the end state!');
          return;
        case FormError.StartDateEqualsEndDate:
          _showErrorMessage('The start date must not match the end date!');
          break;
        case FormError.EndDateSmallerThenStartDate:
          _showErrorMessage('The end date must not be before the start date!');
          break;
        case FormError.Success:
          widget.goal.save(
            activityID: dummyActivity == null ? '' : dummyActivity!.id,
            title: titleController.text,
            image: dummyActivity != null
                ? dummyActivity!.image
                : 'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fgoal.png?alt=media&token=9f580776-3dec-47f6-b4e2-ea8788fa02a1',
            unit: unitSliderController.value,
            startState: startStateController.value,
            currentState: currentStateController.value,
            endState: endStateController.value,
            startDate: Timestamp.fromDate(selectedStartDate!),
            endDate: Timestamp.fromDate(selectedEndDate!),
            isComleted: false,
            isDeleted: false,
          );
          FredericBackend.instance.userManager.state.goalsCount += 1;
          return;
        default:
          _showErrorMessage('Some error happened');
          return;
      }
    } else {
      widget.goal.title = titleController.text;
      widget.goal.startState = startStateController.value;
      widget.goal.currentState = currentStateController.value == 0
          ? dummyCurrentState
          : currentStateController.value;
      widget.goal.endState = endStateController.value;
      widget.goal.startDate = selectedStartDate!;
      widget.goal.endDate = selectedEndDate!;
      widget.goal.unit = unitSliderController.value;
    }
  }

  void addNewActivityTracker(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: BlocProvider.of<FredericSetManager>(context),
        child: ActivityListScreen(
          isSelector: true,
          onSelect: (activity) {
            if (mounted) {
              setState(() {
                if (widget.isNewGoal) {
                  dummyActivity = activity;
                  if (titleController.text.isEmpty ||
                      titleController.text == widget.goal.title) {
                    titleController.text = activity.name;
                  }
                  currentStateController.value =
                      widget.sets![dummyActivity!.id].bestWeight == 0
                          ? widget.sets![dummyActivity!.id].bestReps
                          : widget.sets![dummyActivity!.id].bestWeight;
                  dummyCurrentState = currentStateController.value;
                  startStateController.value = currentStateController.value;

                  trackActivity = true;
                }
                Navigator.of(context).pop();
              });
            }
          },
        ),
      ),
    );
  }

  void showAddProgressScreen(BuildContext context, FredericActivity activity) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BlocProvider.value(
            value: BlocProvider.of<FredericSetManager>(context),
            child: AddProgressScreen(activity),
          );
        });
  }

  String formatDateTime(DateTime date) {
    String day = date.day.toString();
    if (date.day < 10) day = day.padLeft(2, '0');
    String month = date.month.toString();
    if (date.month < 10) month = month.padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  Widget buildHeaderSegment() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(
              ExtraIcons.dumbbell,
              color: theme.mainColor,
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
                style: TextStyle(
                    color: theme.mainColor, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildGoalCard() {
    return SliverToBoxAdapter(
      child: Container(
        height: 70,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GoalCard(
          widget.goal,
          type: GoalCardType.Normal,
          sets: widget.sets ?? null,
          endDate: selectedEndDate,
          startDate: selectedStartDate,
          titleController: titleController,
          currentStateController: currentStateController,
          startStateController: startStateController,
          endStateController: endStateController,
          unitSliderController: unitSliderController,
          interactable: false,
          activity: dummyActivity != null ? dummyActivity! : null,
        ),
      ),
    );
  }

  Widget buildTitleSegment() {
    return SliverToBoxAdapter(
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
    );
  }

  Widget buildGoalStateSegment() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Column(
          children: [
            buildSubHeading('Start', Icons.sports_volleyball),
            SizedBox(height: 12),
            NumberWheel(
              controller: startStateController,
              itemWidth: 0.14,
              numberOfItems: 200,
              startingIndex: startStateController.value.ceil() + 1,
            ),
            SizedBox(height: 12),
            buildSubHeading('End', Icons.sports_mma),
            SizedBox(height: 12),
            NumberWheel(
              controller: endStateController,
              itemWidth: 0.14,
              numberOfItems: 200,
              startingIndex: endStateController.value.ceil() + 1,
            ),
            SizedBox(height: 12),
            if (!trackActivity) buildSubHeading('Unit', Icons.alarm),
            if (!trackActivity)
              UnitSlider(
                startingUnit: Unit.Sets,
                controller: unitSliderController,
                itemWidth: 0.15,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrentStateSegment() {
    return trackActivity
        ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  ActivityCard(
                    dummyActivity!,
                    setList: widget.sets![dummyActivity!.id],
                    onClick: () {},
                    type: ActivityCardType.Small,
                  ),
                  if (widget.isNewGoal)
                    Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => addNewActivityTracker(context),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: theme.mainColor, width: 1.8)),
                                child: Icon(Icons.edit_outlined,
                                    color: theme.mainColor, size: 28),
                              ),
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  trackActivity = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: theme.mainColor, width: 1.8)),
                                child: Icon(CupertinoIcons.delete,
                                    color: theme.mainColor, size: 28),
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                        ))
                ],
              ),
            ),
          )
        : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FredericSlider(
                unit: SliderUnit.Kilograms,
                min: startStateController.value.toDouble(),
                max: endStateController.value.toDouble(),
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
          );
  }

  Widget buildCurrentStateHeadingAndLinkActivity() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            FredericHeading('Current State'),
            if (!trackActivity && widget.isNewGoal)
              Positioned(
                right: 0,
                top: 2,
                child: FredericCard(
                  onTap: () => addNewActivityTracker(context),
                  color: theme.accentColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: Text(
                    'Link Activity',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
      ),
    );
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
              color: theme.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildDatePickerRow(String text, Datepicker datepicker,
      {required DateTime initialDate}) {
    bool datepickerStatus = datepicker == Datepicker.Start
        ? startDatepickerOpened
        : endDatepickerOpened;

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
                  datepickerStatus = !datepickerStatus;
                  if (datepicker == Datepicker.Start) {
                    startDatepickerOpened = !startDatepickerOpened;
                    endDatepickerOpened = false;
                  } else {
                    endDatepickerOpened = !endDatepickerOpened;
                    startDatepickerOpened = false;
                  }
                });
              },
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  datepicker == Datepicker.Start ? startDateText : endDateText,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        AnimatedContainer(
          height: datepickerStatus ? 150 : 0,
          duration: Duration(microseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: theme.cardBorderColor),
          ),
          child: FredericDatePicker(
            initialDate: initialDate,
            onDateChanged: (date) {
              datepicker == Datepicker.Start
                  ? selectedStartDate = date
                  : selectedEndDate = date;
              setState(() {
                datepicker == Datepicker.Start
                    ? startDateText = date.formattedEuropean()
                    : endDateText = date.formattedEuropean();
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    startStateController.dispose();
    endStateController.dispose();
    currentStateController.dispose();
    titleController.dispose();
    unitSliderController.dispose();
    super.dispose();
  }
}
