import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_slider.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:frederic/widgets/workout_list_screen/workout_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditWorkoutDataScreen extends StatefulWidget {
  const EditWorkoutDataScreen(this.workout, {Key? key}) : super(key: key);

  final FredericWorkout workout;

  @override
  _EditWorkoutDataScreenState createState() => _EditWorkoutDataScreenState();
}

class _EditWorkoutDataScreenState extends State<EditWorkoutDataScreen> {
  final Color disabledBorderColor = Color(0xFFE2E2E2);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  color: kMainColor,
                ),
                SizedBox(width: 32),
                Text(
                  'Edit workout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Expanded(child: Container()),
                Text(
                  'Save',
                  style:
                      TextStyle(color: kMainColor, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )),
          SliverDivider(),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: WorkoutCard(widget.workout),
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
              onChanged: (double value) {
                print(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
