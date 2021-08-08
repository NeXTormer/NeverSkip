import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
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
  TextEditingController titleController = TextEditingController();

  String dummyTitle = '';
  num dummyStartState = 0;
  num dummyCurrentState = 0;
  num dummyEndState = 0;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
