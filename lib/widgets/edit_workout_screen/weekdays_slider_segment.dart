import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider.dart';

enum Direction { left, right }

///
/// Part of the EditWorkoutScreen. Responsible for the
/// display of the Weekdays Slider
///
class WeekdaysSliderSegment extends StatelessWidget {
  WeekdaysSliderSegment(this.workout, this.sliderController);

  final WeekdaySliderController? sliderController;
  final FredericWorkout? workout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildWeekdayArrowIndicator(8, Direction.left),
        buildWeekdayArrowIndicator(8, Direction.right),
        WeekdaysSlider(
          controller: sliderController,
          onSelectDay: null,
          weekCount: workout!.period,
        ),
      ],
    );
  }

  Widget buildWeekdayArrowIndicator(double padding, Direction direction) {
    return Positioned.fill(
      left: direction == Direction.left ? padding : 0,
      right: direction == Direction.right ? padding : 0,
      child: Align(
        alignment: direction == Direction.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Icon(
          direction == Direction.left
              ? Icons.arrow_back_ios
              : Icons.arrow_forward_ios,
          size: 15,
          color: kTextColor.withOpacity(0.8),
        ),
      ),
    );
  }
}
