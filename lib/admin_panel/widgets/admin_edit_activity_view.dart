import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/admin_panel/backend/admin_icon_manager.dart';
import 'package:frederic/admin_panel/screens/admin_list_icon_screen.dart';
import 'package:frederic/admin_panel/widgets/admin_select_activity_type.dart';
import 'package:frederic/admin_panel/widgets/admin_select_muscle_group.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/edit_workout_activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/number_wheel.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class AdminEditActivityView extends StatefulWidget {
  const AdminEditActivityView(this.activity, {Key? key}) : super(key: key);

  final FredericActivity activity;

  @override
  _AdminEditActivityViewState createState() => _AdminEditActivityViewState();
}

class _AdminEditActivityViewState extends State<AdminEditActivityView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NumberSliderController repsController = NumberSliderController();
  NumberSliderController setsController = NumberSliderController();

  String? selectedIcon;

  FredericActivityType type = FredericActivityType.None;
  List<FredericActivityMuscleGroup> muscleGroups =
      <FredericActivityMuscleGroup>[];

  @override
  void initState() {
    type = widget.activity.type;
    muscleGroups = widget.activity.muscleGroups;
    setsController.value = widget.activity.recommendedSets;
    repsController.value = widget.activity.recommendedReps;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericActivityManager, FredericActivityListData>(
      buildWhen: (current, next) => next.changed.contains(widget.activity.id),
      builder: (context, activityListData) => FredericCard(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ActivityCard(
                      widget.activity,
                      onClick: () {},
                    ),
                  ),
                  FredericHeading('Icon'),
                  const SizedBox(height: 8),
                  Container(
                      height: 88,
                      child: Row(
                        children: [
                          PictureIcon(selectedIcon ?? widget.activity.image),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: FredericButton(
                                'Change Icon',
                                inverted: true,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) {
                                        return BlocProvider<
                                            AdminIconManager>.value(
                                          value:
                                              BlocProvider.of<AdminIconManager>(
                                                  context),
                                          child: Container(
                                            height:
                                                MediaQuery.of(ctx).size.height *
                                                    0.8,
                                            child: AdminListIconScreen(
                                              onSelect: (icon) {
                                                Navigator.of(ctx).pop();
                                                widget.activity.updateData(
                                                    newImage: icon.url);
                                                FredericBackend
                                                    .instance.activityManager
                                                    .add(
                                                        FredericActivityUpdateEvent(
                                                            widget.activity));
                                                setState(() {
                                                  selectedIcon = icon.url;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(height: 16),
                  FredericHeading('Name'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: FredericTextField(
                      widget.activity.name,
                      controller: nameController,
                      text: widget.activity.name,
                      icon: null,
                      maxLines: 2,
                      height: 80,
                      verticalContentPadding: 12,
                    ),
                  ),
                  FredericHeading('Description'),
                  const SizedBox(height: 8),
                  FredericTextField(
                    widget.activity.description,
                    controller: descriptionController,
                    text: widget.activity.description,
                    icon: null,
                    maxLines: 4,
                    height: 120,
                    verticalContentPadding: 12,
                  ),
                  FredericHeading('Activity Type'),
                  const SizedBox(height: 8),
                  AdminSelectActivityType(
                    selectedType: type,
                    onChange: (newType) => setState(() => type = newType),
                  ),
                  const SizedBox(height: 16),
                  FredericHeading('Muscle Groups'),
                  const SizedBox(height: 8),
                  AdminSelectMuscleGroup(
                      muscleGroups: muscleGroups,
                      removeMuscleGroup: (group) =>
                          setState(() => muscleGroups.remove(group)),
                      addMuscleGroup: (group) =>
                          setState(() => muscleGroups.add(group))),
                  const SizedBox(height: 16),
                  FredericHeading('Recommended sets and reps'),
                  const SizedBox(height: 8),
                  SelectSetsAndRepsPopup(
                      hideDescription: true,
                      setsSliderController: setsController,
                      repsSliderController: repsController),
                  const SizedBox(height: 16),
                  FredericHeading('Save'),
                  const SizedBox(height: 8),
                  FredericButton('Save', onPressed: saveData),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveData() {
    if (widget.activity.isEmpty) {
      var activity = FredericActivity.make(
          name: nameController.text,
          owner: 'global',
          description: descriptionController.text,
          image: selectedIcon ??
              'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe',
          recommendedReps: repsController.value.toInt(),
          recommendedSets: setsController.value.toInt(),
          muscleGroups: muscleGroups,
          type: type);
      FredericBackend.instance.activityManager
          .add(FredericActivityCreateEvent(activity));
    } else {
      var activity = widget.activity;
      activity.updateData(
          newName: nameController.text,
          newDescription: descriptionController.text,
          newType: type,
          newMuscleGroups: muscleGroups,
          newRecommendedSets: setsController.value.toInt(),
          newRecommendedReps: repsController.value.toInt());
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(activity));
    }
  }
}
