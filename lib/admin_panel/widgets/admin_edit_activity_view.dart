import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/widgets/admin_select_activity_type.dart';
import 'package:frederic/admin_panel/widgets/admin_select_muscle_group.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/edit_workout_activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
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
    return FredericCard(
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
                        PictureIcon(widget.activity.image),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: FredericButton(
                              'Change Icon',
                              inverted: true,
                              onPressed: () {},
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
                FredericButton('Save', onPressed: () {}),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
