import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/activity_screen/activity_musclegroup_button.dart';

import '../../state/activity_filter_controller.dart';
import '../standard_elements/frederic_heading.dart';

enum MuscleGroup { Arms, Chest, Back, Abs, Legs, None, All }

class ActivityFilterSegment extends StatefulWidget {
  ActivityFilterSegment({required this.filterController});

  final ActivityFilterController filterController;

  @override
  _ActivityFilterSegmentState createState() => _ActivityFilterSegmentState();
}

class _ActivityFilterSegmentState extends State<ActivityFilterSegment> {
  int selectedIndex = 0;

  final allKey = GlobalKey();
  final armsKey = GlobalKey();
  final chestKey = GlobalKey();
  final backKey = GlobalKey();
  final absKey = GlobalKey();
  final legsKey = GlobalKey();

  List<GlobalKey> keys = <GlobalKey>[];

  final dotKey = GlobalKey();

  double positionedX = 0;

  @override
  void initState() {
    keys.add(allKey);
    keys.add(armsKey);
    keys.add(chestKey);
    keys.add(backKey);
    keys.add(absKey);
    keys.add(legsKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 0; //MediaQuery.of(context).size.width / 16;
    try {
      return SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
          child: Column(
            children: [
              FredericHeading.translate('exercises.muscle_groups.title'),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivityMuscleGroupButton(
                          tr('exercises.muscle_groups.all'),
                          key: allKey,
                          rightPadding: padding,
                          isActive: selectedIndex == 0, onPressed: () {
                        setState(() {
                          handleMuscleFilters(MuscleGroup.All);
                          selectedIndex = 0;
                        });
                      }),
                      ActivityMuscleGroupButton(
                          tr('exercises.muscle_groups.arms'),
                          key: armsKey,
                          rightPadding: padding,
                          isActive: selectedIndex == 1, onPressed: () {
                        setState(() {
                          handleMuscleFilters(MuscleGroup.Arms);
                          selectedIndex = 1;
                        });
                      }),
                      ActivityMuscleGroupButton(
                          tr('exercises.muscle_groups.chest'),
                          key: chestKey,
                          rightPadding: padding,
                          isActive: selectedIndex == 2,
                          onPressed: () => setState(() {
                                handleMuscleFilters(MuscleGroup.Chest);
                                selectedIndex = 2;
                              })),
                      ActivityMuscleGroupButton(
                          tr('exercises.muscle_groups.back'),
                          key: backKey,
                          rightPadding: padding,
                          isActive: selectedIndex == 3,
                          onPressed: () => setState(() {
                                handleMuscleFilters(MuscleGroup.Back);
                                selectedIndex = 3;
                              })),
                      ActivityMuscleGroupButton(
                          tr('exercises.muscle_groups.abs'),
                          key: absKey,
                          rightPadding: padding,
                          isActive: selectedIndex == 4,
                          onPressed: () => setState(() {
                                handleMuscleFilters(MuscleGroup.Abs);
                                selectedIndex = 4;
                              })),
                      ActivityMuscleGroupButton(
                          tr('exercises.muscle_groups.legs'),
                          key: legsKey,
                          rightPadding: padding,
                          isActive: selectedIndex == 5,
                          onPressed: () => setState(() {
                                handleMuscleFilters(MuscleGroup.Legs);
                                selectedIndex = 5;
                              })),
                      SizedBox(width: 12)
                    ],
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                    bottom: 0,
                    left: keys[selectedIndex].positionedDifference(dotKey),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: theme.mainColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      );
    } catch (e) {
      print(e);
      return Container();
    }
  }

  void handleMuscleFilters(MuscleGroup activeFilter) {
    switch (activeFilter) {
      case MuscleGroup.Arms:
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.legs = false;
        widget.filterController.abs = false;
        widget.filterController.arms = true;

        break;
      case MuscleGroup.Chest:
        widget.filterController.arms = false;
        widget.filterController.back = false;
        widget.filterController.abs = false;
        widget.filterController.chest = true;
        widget.filterController.legs = false;
        break;
      case MuscleGroup.Back:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.abs = false;
        widget.filterController.legs = false;
        widget.filterController.back = true;
        break;
      case MuscleGroup.Abs:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.legs = false;
        widget.filterController.abs = true;
        break;
      case MuscleGroup.Legs:
        widget.filterController.arms = false;
        widget.filterController.chest = false;
        widget.filterController.back = false;
        widget.filterController.abs = false;
        widget.filterController.legs = true;
        break;
      case MuscleGroup.All:
        widget.filterController.arms = true;
        widget.filterController.chest = true;
        widget.filterController.back = true;
        widget.filterController.abs = true;
        widget.filterController.legs = true;
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

extension GlobalKeyExtension on GlobalKey {
  double positionedDifference(GlobalKey other) {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject
        ?.getTransformTo(other.currentContext?.findRenderObject())
        .getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      Rect? rect =
          renderObject?.paintBounds.shift(Offset(translation.x, translation.y));
      if (rect != null) {
        return rect.left - 16;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}
