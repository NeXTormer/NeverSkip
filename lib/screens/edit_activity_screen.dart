import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/edit_activity_screen/activity_muscle_group_selector.dart';
import 'package:frederic/widgets/edit_activity_screen/activity_type_selector.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/dummy_activity_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/number_wheel.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../main.dart';

class EditActivityScreen extends StatefulWidget {
  const EditActivityScreen(this.activity, {Key? key}) : super(key: key);

  final FredericActivity activity;

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  String? icon;
  String name = '';
  String description = '';

  bool deleteButtonLoading = false;

  FredericActivityType type = FredericActivityType.Weighted;

  List<FredericActivityMuscleGroup> muscleGroups =
      <FredericActivityMuscleGroup>[];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  NumberSliderController repsController = NumberSliderController();
  NumberSliderController setsController = NumberSliderController();

  @override
  void initState() {
    muscleGroups = widget.activity.muscleGroups;
    type = widget.activity.type == FredericActivityType.None
        ? FredericActivityType.Weighted
        : widget.activity.type;
    icon = widget.activity.image;
    name = widget.activity.name;
    description = widget.activity.description;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      descriptionController.addListener(() {
        setState(() {
          if (descriptionController.text.isNotEmpty)
            description = descriptionController.text;
        });
      });
      nameController.addListener(() {
        setState(() {
          if (nameController.text.isNotEmpty) name = nameController.text;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool editing = widget.activity.id != '';

    return FredericScaffold(
        body: CustomScrollView(
      controller: ModalScrollController.of(context),
      slivers: [
        SliverToBoxAdapter(
            child: FredericBasicAppBar(
                title: editing ? 'Edit your Activity' : 'Add a new Activity',
                icon: GestureDetector(
                  onTap: () {
                    saveData();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    editing ? 'Save' : 'Add',
                    style: TextStyle(
                        color:
                            theme.isColorful ? Colors.white : theme.mainColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                leadingIcon: Icon(
                  ExtraIcons.settings,
                  color: theme.isColorful ? Colors.white : theme.mainColor,
                ))),
        if (theme.isMonotone) SliverToBoxAdapter(child: FredericDivider()),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: DummyActivityCard(
            icon: widget.activity.image,
            name: name,
            description: description,
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
              'Name',
              maxLength: 42,
              text: editing ? widget.activity.name : '',
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
              'Description',
              controller: descriptionController,
              text: editing ? widget.activity.description : '',
              icon: null,
              maxLines: 3,
              maxLength: 240,
              height: 80,
              verticalContentPadding: 12,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FredericHeading('Type'),
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ActivityTypeSelector(
            selected: type,
            onSelect: (selection) {
              setState(() {
                type = selection;
              });
            },
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FredericHeading('Muscle Groups'),
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ActivityMuscleGroupSelector(
            muscleGroups: muscleGroups,
            addMuscleGroup: (g) => setState(() {
              muscleGroups.add(g);
            }),
            removeMuscleGroup: (g) => setState(() {
              muscleGroups.remove(g);
            }),
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FredericHeading('Recommended Sets'),
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: NumberWheel(
                controller: setsController,
                startingIndex:
                    editing ? widget.activity.recommendedSets + 1 : 4),
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FredericHeading('Recommended Reps'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: NumberWheel(
                controller: repsController,
                startingIndex:
                    editing ? widget.activity.recommendedReps + 1 : 11),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(24),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (editing)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: FredericButton(
                        'Delete',
                        mainColor: theme.negativeColor,
                        onPressed: () => delete(context),
                      ),
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: FredericButton(
                    editing ? 'Save' : 'Add',
                    onPressed: () {
                      saveData();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(8),
        ),
      ],
    ));
  }

  void saveData() {
    if (widget.activity.id == '') {
      FredericBackend.instance.activityManager.add(FredericActivityCreateEvent(
          FredericActivity.make(
              name: name,
              description: description,
              image: widget.activity.image,
              recommendedReps: repsController.value.toInt(),
              recommendedSets: setsController.value.toInt(),
              muscleGroups: muscleGroups,
              owner: FredericBackend.instance.userManager.state.id,
              type: type)));
    } else {
      widget.activity.updateData(
          newName: name,
          newType: type,
          newImage: icon,
          newDescription: description,
          newMuscleGroups: muscleGroups,
          newRecommendedReps: repsController.value.toInt(),
          newRecommendedSets: setsController.value.toInt());

      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(widget.activity));
    }
  }

  void delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: Material(
                color: Colors.transparent,
                child: FredericActionDialog(
                  onConfirm: () async {
                    setState(() {
                      deleteButtonLoading = true;
                    });
                    await FredericBackend.instance.activityManager
                        .deleteActivity(widget.activity);
                    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  },
                  title: 'Confirm deletion',
                  destructiveAction: true,
                  child: deleteButtonLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Do you want to delete the Exercise? This cannot be undone!',
                          textAlign: TextAlign.center),
                ),
              ),
            ));
  }
}
