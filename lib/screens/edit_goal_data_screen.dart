import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/home_screen/goal_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_date_picker.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditGoalDataScreen extends StatefulWidget {
  EditGoalDataScreen(this.goal, {Key? key}) : super(key: key) {
    isNewGoal = goal.goalID == 'new';
  }
  final FredericGoal goal;
  late final bool isNewGoal;

  @override
  _EditGoalDataScreenState createState() => _EditGoalDataScreenState();
}

class _EditGoalDataScreenState extends State<EditGoalDataScreen> {
  final TextEditingController titleController = TextEditingController();
  final NumberSliderController startStateController = NumberSliderController();
  final NumberSliderController currentStateController =
      NumberSliderController();

  String dateText = '';
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

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      titleController.addListener(() {
        setState(() {
          dummyTitle = titleController.text;
        });
      });
    });
    super.initState();
  }

  String formatDateTime(DateTime date) {
    String day = date.day.toString();
    if (date.day < 10) day = day.padLeft(2, '0');
    String month = date.month.toString();
    if (date.month < 10) month = month.padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: CustomScrollView(
        controller: ModalScrollController.of(context),
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(bottom: 12)),
          SliverToBoxAdapter(
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
                      // saveData();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.isNewGoal ? 'Create' : 'Save',
                      style: TextStyle(
                          color: kMainColor, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverDivider(),
          // TODO Adapt Progressbar to goal card
          SliverToBoxAdapter(
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GoalCard.dummy(
                widget.goal,
                title: dummyTitle,
              ),
            ),
          ),
          SliverDivider(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Title'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericTextField(
                widget.goal.title,
                maxLength: 30,
                text: widget.goal.title,
                icon: null,
                controller: titleController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Activity'),
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
              // TODO Adapt NumberSlider to goal card
              child: Column(
                children: [
                  buildSubHeading('Start', Icons.star_outline),
                  SizedBox(height: 12),
                  NumberSlider(
                    controller: startStateController,
                    itemWidth: 0.14,
                    numberOfItems: 100,
                    startingIndex: dummyStartState.toInt(),
                  ),
                  SizedBox(height: 12),
                  buildSubHeading('Current', Icons.star_outline),
                  SizedBox(height: 12),
                  NumberSlider(
                    controller: currentStateController,
                    itemWidth: 0.14,
                    numberOfItems: (dummyEndState - dummyStartState).toInt(),
                    startingIndex: dummyCurrentState.toInt(),
                  ),
                  SizedBox(height: 12),
                  buildSubHeading('End', Icons.star_outline),
                  SizedBox(height: 12),
                  NumberSlider(
                    controller: startStateController,
                    itemWidth: 0.14,
                    numberOfItems: 100,
                    startingIndex: dummyStartState.toInt(),
                  ),
                ],
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
        ],
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

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
