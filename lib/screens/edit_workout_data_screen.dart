import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/extensions.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_date_picker.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:frederic/widgets/workout_list_screen/workout_card.dart';

class EditWorkoutDataScreen extends StatefulWidget {
  EditWorkoutDataScreen(this.workout, {Key? key}) : super(key: key) {
    isNewWorkout = workout.id == '';
    FredericBackend.instance.analytics.analytics
        .setCurrentScreen(screenName: 'edit-workout-data-screen');
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      descriptionController.addListener(() {
        setState(() {
          if (descriptionController.text.isNotEmpty)
            dummyDescription = descriptionController.text;
        });
      });
      nameController.addListener(() {
        setState(() {
          if (nameController.text.isNotEmpty) dummyName = nameController.text;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: FredericBasicAppBar(
            title: widget.isNewWorkout
                ? tr('misc.create_workout')
                : tr('misc.edit_workout'),
            leadingIcon: Icon(
              ExtraIcons.settings,
              color: theme.isColorful ? Colors.white : theme.mainColor,
            ),
            icon: GestureDetector(
              onTap: () {
                saveData();
                Navigator.of(context).pop();
              },
              child: Text(
                widget.isNewWorkout ? tr('create') : tr('save'),
                style: TextStyle(
                    color: theme.isColorful ? Colors.white : theme.mainColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )),
          if (theme.isBright) SliverDivider(),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              child: FredericHeading.translate('misc.name'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericTextField(
                widget.workout.name,
                maxLength: 42,
                text: widget.isNewWorkout ? '' : widget.workout.name,
                icon: null,
                controller: nameController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericHeading.translate('misc.description'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FredericTextField(
                widget.workout.description,
                controller: descriptionController,
                text: widget.isNewWorkout ? '' : widget.workout.description,
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
              child: FredericHeading.translate('misc.duration'),
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
                      Text('misc.repeating').tr(),
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
                      Text('misc.number_of_activities').tr(),
                      Expanded(child: Container()),
                      Text(
                          '${widget.workout.activities.totalNumberOfActivities}'),
                      SizedBox(width: 5)
                    ],
                  ),
                  SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('misc.start_day').tr(),
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
                      child: FredericDatePicker(
                          initialDate: widget.workout.startDate,
                          onDateChanged: (date) {
                            selectedStartDate = date;
                            setState(() {
                              dateText = date.formattedEuropean();
                            });
                          })),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.workout.canEdit && !widget.isNewWorkout)
                        Expanded(
                            flex: 1,
                            child: FredericButton(
                              tr('delete'),
                              mainColor: Colors.red,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => FredericActionDialog(
                                          onConfirm: () {
                                            FredericBackend.instance.analytics
                                                .logWorkoutDeleted();
                                            FredericBackend
                                                .instance.workoutManager
                                                .add(FredericWorkoutDeleteEvent(
                                                    widget.workout));

                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (timeStamp) {
                                              Navigator.of(ctx).pop();
                                              Navigator.of(ctx).pop();
                                            });
                                          },
                                          title: tr('confirm_delete'),
                                          destructiveAction: true,
                                          child: Text('misc.delete_workout',
                                                  textAlign: TextAlign.center)
                                              .tr(),
                                        ));
                              },
                              inverted: true,
                            )),
                      if (widget.workout.canEdit && !widget.isNewWorkout)
                        SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child: FredericButton(
                              widget.isNewWorkout ? tr('create') : tr('save'),
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
    widget.workout.updateData(
        newName: dummyName,
        newDescription: dummyDescription,
        newImage: widget.workout.image,
        newPeriod: dummyPeriod,
        newRepeating: dummyRepeating,
        newStartDate: widget.isNewWorkout
            ? (selectedStartDate ?? DateTime.now())
            : selectedStartDate);
    if (widget.isNewWorkout) {
      FredericBackend.instance.analytics.logWorkoutCreated();

      FredericBackend.instance.workoutManager
          .add(FredericWorkoutCreateEvent(widget.workout));
    } else {
      FredericBackend.instance.analytics.logWorkoutSaved();
      FredericBackend.instance.workoutManager.updateWorkoutInDB(widget.workout);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
