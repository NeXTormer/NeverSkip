import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/edit_workout_screen/weekday_slider_day_card.dart';

enum Direction { left, right }

///
/// Part of the EditWorkoutScreen. Responsible for the
/// display of the Weekdays Slider
///
class WeekdaysSliderSegment extends StatelessWidget {
  WeekdaysSliderSegment(
      {required this.pageController,
      required this.weekdaysSliderController,
      required this.workout});

  final PageController pageController;
  final FredericWorkout workout;
  final WeekdaysSliderController weekdaysSliderController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (workout.period != 1) buildWeekdayArrowIndicator(8, Direction.left),
        if (workout.period != 1) buildWeekdayArrowIndicator(8, Direction.right),
        WeekdaysSlider(
          startingDate: workout.startDate,
          pageController: pageController,
          workout: workout,
          weekdaysSliderController: weekdaysSliderController,
          weekCount: workout.period,
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
        child: GestureDetector(
          onTap: () {
            direction == Direction.left
                ? pageController.previousPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOutCirc)
                : pageController.nextPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOutCirc);
          },
          child: Icon(
            direction == Direction.left
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
            size: 15,
            color: theme.mainColor,
          ),
        ),
      ),
    );
  }
}

///
/// Responsible for the creation of the week sections (ExpandablePageView) and
/// the corresponding week days (WeekDaysSliderDayButton).
///
class WeekdaysSlider extends StatefulWidget {
  WeekdaysSlider(
      {this.weekCount = 1,
      required this.startingDate,
      required this.pageController,
      required this.workout,
      required this.weekdaysSliderController,
      Key? key})
      : super(key: key);

  final DateTime startingDate;
  final FredericWorkout workout;
  final PageController pageController;
  final WeekdaysSliderController weekdaysSliderController;
  final int weekCount;

  @override
  _WeekdaysSliderState createState() => _WeekdaysSliderState();
}

class _WeekdaysSliderState extends State<WeekdaysSlider> {
  int selectedDate = 0;

  late PageController weekPageController;

  @override
  void initState() {
    widget.weekdaysSliderController.setCallback(changeDayCallback);
    weekPageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: PageView(
          controller: weekPageController,
          children: List.generate(
              widget.weekCount,
              (week) => Padding(
                    // Somehow the widget is not centred, therefore an asymmetric
                    // padding was chosen here.
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: Container(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(7, (index) {
                            return GestureDetector(
                              onTap: () => handleChangeDay(index + (week * 7)),
                              child: WeekDaysSliderDayButton(
                                onSwap: (first, second) {
                                  widget.workout.swapDays(first, second);
                                },
                                dayIndex: index + (week * 7),
                                selectedDate: selectedDate,
                                date: widget.startingDate.add(
                                  Duration(
                                    days: (index + (week * 7)),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ))),
    );
  }

  void changeDayCallback(int index) {
    int week = index ~/ 7;
    if (weekPageController.page?.toInt() != week) {
      weekPageController.animateToPage(week,
          duration: Duration(milliseconds: 250), curve: Curves.easeInOutCirc);
    }
    setState(() {
      selectedDate = index;
    });
  }

  void handleChangeDay(int index) {
    if (((widget.pageController.page?.toInt() ?? 0) - index).abs() <= 1) {
      widget.pageController.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.easeInOutCirc);
    } else {
      widget.pageController.jumpToPage(index);
    }
  }
}
