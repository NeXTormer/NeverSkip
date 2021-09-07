import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/extensions.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_date_picker.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:frederic/widgets/workout_list_screen/workout_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditWorkoutDataScreen extends StatefulWidget {
  EditWorkoutDataScreen(this.workout, {Key? key}) : super(key: key) {
    isNewWorkout = workout.workoutID == 'new';
  }

  final FredericWorkout workout;
  late final bool isNewWorkout;

  @override
  _EditWorkoutDataScreenState createState() => _EditWorkoutDataScreenState();
}

class _EditWorkoutDataScreenState extends State<EditWorkoutDataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String dummyDescription = '';
  String dummyName = '';
  bool dummyRepeating = false;
  int dummyPeriod = 1;

  bool isRepeating = false;
  bool datePickerOpen = false;
  bool datePickerVisible = false;

  DateTime? selectedStartDate;

  String dateText = '';

  int totalActivities = 0;

  bool setStateNameController = true;
  bool setStateDescriptionController = true;

  @override
  void initState() {
    isRepeating = widget.workout.repeating;
    dateText = widget.workout.startDate.formattedEuropean();
    dummyDescription = widget.workout.description;
    dummyName = widget.workout.name;
    dummyRepeating = widget.workout.repeating;
    dummyPeriod = widget.workout.period;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      descriptionController.addListener(() {
        setState(() {
          dummyDescription = descriptionController.text;
        });
      });
      nameController.addListener(() {
        setState(() {
          dummyName = nameController.text;
        });
      });
    });

    for (List<FredericWorkoutActivity> list
        in widget.workout.activities.activities) {
      totalActivities += list.length;
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
          SliverPadding(padding: EdgeInsets.only(bottom: 12)),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  ExtraIcons.settings,
                  color: theme.mainColor,
                ),
                SizedBox(width: 32),
                Text(
                  widget.isNewWorkout ? 'Create workout' : 'Edit workout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    saveData();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    widget.isNewWorkout ? 'Create' : 'Save',
                    style: TextStyle(
                        color: theme.mainColor, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          )),
          SliverDivider(),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: WorkoutCard.dummy(
              widget.workout,
              description: dummyDescription,
              period: dummyPeriod,
              repeating: dummyRepeating,
              name: dummyName,
            ),
          )),
          SliverDivider(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Name'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericTextField(
                widget.workout.name,
                maxLength: 42,
                text: widget.workout.name,
                icon: null,
                controller: nameController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Description'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericTextField(
                widget.workout.name,
                controller: descriptionController,
                text: widget.workout.description,
                icon: null,
                maxLines: 2,
                maxLength: 110,
                height: 60,
                verticalContentPadding: 12,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading('Weeks'),
            ),
          ),
          SliverToBoxAdapter(
            child: FredericSlider(
              min: 1,
              max: 8,
              value: widget.workout.period.toDouble(),
              onChanged: (double value) {
                setState(() {
                  dummyPeriod = value.toInt();
                });
              },
            ),
          ),
          SliverPadding(padding: const EdgeInsets.only(bottom: 42)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Repeating'),
                      CupertinoSwitch(
                          value: isRepeating,
                          onChanged: (value) {
                            setState(() {
                              isRepeating = value;
                              dummyRepeating = value;
                            });
                          },
                          activeColor: theme.mainColor)
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Number of activities'),
                      Expanded(child: Container()),
                      Text('$totalActivities'),
                      SizedBox(width: 5)
                    ],
                  ),
                  SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start day'),
                      FredericCard(
                        width: 100,
                        onTap: () {
                          setState(() {
                            datePickerOpen = !datePickerOpen;
                          });
                        },
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            dateText,
                            maxLines: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  AnimatedContainer(
                      height: datePickerOpen ? 128 : 0,
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: theme.cardBorderColor)),
                      child: true
                          ? FredericDatePicker(
                              initialDate: widget.workout.startDate,
                              onDateChanged: (date) {
                                selectedStartDate = date;
                                setState(() {
                                  dateText = date.formattedEuropean();
                                });
                              })
                          : Container()),
                  SizedBox(
                      height: true
                          ? 16
                          : (MediaQuery.of(context).size.height < 950
                              ? 950 - MediaQuery.of(context).size.height
                              : 16)),
                  Row(
                    children: [
                      if (widget.workout.canEdit)
                        Expanded(
                            flex: 1,
                            child: FredericButton(
                              'Delete',
                              mainColor: Colors.red,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => FredericActionDialog(
                                          onConfirm: () {
                                            FredericBackend
                                                .instance.workoutManager
                                                .add(FredericWorkoutDeleteEvent(
                                                    widget.workout));

                                            // Navigator.of(context).pop();
                                            WidgetsBinding.instance
                                                ?.addPostFrameCallback(
                                                    (timeStamp) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          title: 'Confirm deletion',
                                          destructiveAction: true,
                                          child: Text(
                                              'Do you want to delete the workout plan? This cannot be undone!',
                                              textAlign: TextAlign.center),
                                        ));
                              },
                              inverted: true,
                            )),
                      if (widget.workout.canEdit) SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child: FredericButton(
                              widget.isNewWorkout ? 'Create' : 'Save',
                              onPressed: () {
                            saveData();
                            Navigator.of(context).pop();
                          }))
                    ],
                  ),
                  SizedBox(height: 16)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveData() {
    if (widget.isNewWorkout) {
      widget.workout.save(
          title: dummyName,
          description: dummyDescription,
          image: widget.workout.image,
          period: dummyPeriod,
          repeating: dummyRepeating,
          startDate: selectedStartDate ?? DateTime.now());
    } else {
      if (selectedStartDate != null &&
          widget.workout.startDate != selectedStartDate!) {
        widget.workout.startDate = selectedStartDate!;
      }
      widget.workout.name = dummyName;
      widget.workout.description = dummyDescription;
      widget.workout.repeating = dummyRepeating;
      widget.workout.period = dummyPeriod;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
