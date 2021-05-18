import 'package:flutter/material.dart';
import 'package:frederic/widgets/activity_screen/activity_musclegroup_button.dart';

import '../standard_elements/frederic_heading.dart';
import 'activity_filter_controller.dart';

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
            Row(
              children: [
                ActivityMuscleGroupButton('Arms',
                    isActive: widget.filterController.arms!,
                    onPressed: () => setState(() {
                          widget.filterController.arms =
                              !widget.filterController.arms!;
                        })),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Chest',
                    isActive: widget.filterController.chest!,
                    onPressed: () => setState(() {
                          widget.filterController.chest =
                              !widget.filterController.chest!;
                        })),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Abs',
                    isActive: widget.filterController.abs!,
                    onPressed: () => setState(() {
                          widget.filterController.abs =
                              !widget.filterController.abs!;
                        })),
                SizedBox(width: aspectRatio),
                ActivityMuscleGroupButton('Legs',
                    isActive: widget.filterController.legs!,
                    onPressed: () => setState(() {
                          widget.filterController.legs =
                              !widget.filterController.legs!;
                        })),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
