import 'package:flutter/material.dart';
import 'package:frederic/widgets/activity_screen/activity_musclegroup_button.dart';

import '../standard_elements/frederic_heading.dart';
import 'activity_filter_controller.dart';

enum MuscleGroup { Arms, Chest, Back, Abs, Legs, None }

class ActivityFilterSegment extends StatefulWidget {
  ActivityFilterSegment({required this.filterController});

  final ActivityFilterController filterController;

  @override
  _ActivityFilterSegmentState createState() => _ActivityFilterSegmentState();
}

class _ActivityFilterSegmentState extends State<ActivityFilterSegment> {
  @override
  Widget build(BuildContext context) {
    final double aspectRatio = MediaQuery.of(context).size.width / 10;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: Column(
          children: [
            FredericHeading(
              'Muscle Groups',
              onPressed: () {},
            ),
            // TODO Update Backend functionality for case:
            // No filter is selected, so every activity is shown
            // Default value = false for all filters
            Row(
              children: [
                ActivityMuscleGroupButton('Arms',
                    isActive: widget.filterController.arms, onPressed: () {
                  setState(() {
                    handleMuscleFilters(MuscleGroup.Arms);
                    widget.filterController.arms =
                        !widget.filterController.arms;
                  });
                }),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Chest',
                    isActive: widget.filterController.chest,
                    onPressed: () => setState(() {
                          handleMuscleFilters(MuscleGroup.Chest);
                          widget.filterController.chest =
                              !widget.filterController.chest;
                        })),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Back',
                    isActive: widget.filterController.back,
                    onPressed: () => setState(() {
                          handleMuscleFilters(MuscleGroup.Back);
                          widget.filterController.back =
                              !widget.filterController.back;
                        })),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Abs',
                    isActive: widget.filterController.abs,
                    onPressed: () => setState(() {
                          handleMuscleFilters(MuscleGroup.Abs);
                          widget.filterController.abs =
                              !widget.filterController.abs;
                        })),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Legs',
                    isActive: widget.filterController.legs,
                    onPressed: () => setState(() {
                          handleMuscleFilters(MuscleGroup.Legs);
                          widget.filterController.legs =
                              !widget.filterController.legs;
                        })),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void handleMuscleFilters(MuscleGroup activeFilter) {
    switch (activeFilter) {
      case MuscleGroup.Arms:
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.legs = false;
        widget.filterController.abs = false;
        break;
      case MuscleGroup.Chest:
        widget.filterController.arms = false;
        widget.filterController.back = false;
        widget.filterController.abs = false;
        widget.filterController.legs = false;
        break;
      case MuscleGroup.Back:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.abs = false;
        widget.filterController.legs = false;
        break;
      case MuscleGroup.Abs:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.legs = false;
        break;
      case MuscleGroup.Legs:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.abs = false;
        break;
      default:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.legs = false;
        widget.filterController.abs = false;
        break;
    }
  }
}
