import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frederic/screens/edit_workout_screen.dart';

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
  final FredericWorkout? workout;
  final WeekdaysSliderController? weekdaysSliderController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildWeekdayArrowIndicator(8, Direction.left),
        buildWeekdayArrowIndicator(8, Direction.right),
        WeekdaysSlider(
          startingDate: workout!.startDate,
          pageController: pageController,
          weekdaysSliderController: weekdaysSliderController,
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

///
/// Responsible for the creation of the week sections (ExpandablePageView) and
/// the corresponding week days (WeekDaysSliderDayButton).
///
class WeekdaysSlider extends StatefulWidget {
  WeekdaysSlider(
      {this.weekCount = 1,
      required this.startingDate,
      required this.pageController,
      required this.weekdaysSliderController,
      Key? key})
      : super(key: key);

  final DateTime? startingDate;
  final PageController? pageController;
  final WeekdaysSliderController? weekdaysSliderController;
  final int weekCount;

  @override
  _WeekdaysSliderState createState() => _WeekdaysSliderState();
}

class _WeekdaysSliderState extends State<WeekdaysSlider> {
  int selectedDate = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ExpandablePageView(
        animateFirstPage: true,
        itemCount: widget.weekCount,
        itemBuilder: (context, week) {
          widget.weekdaysSliderController!.setCallback(changeDayCallback);
          return Padding(
            // TODO
            // Somehow the widget is not centred, therefore an asymmetric
            // padding was chosen here.
            padding: const EdgeInsets.only(left: 15, right: 20),
            child: Container(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...List.generate(7, (index) {
                      return InkWell(
                        onTap: () {
                          handleChangeDay(index + (week * 7));
                        },
                        child: WeekDaysSliderDayButton(
                          dayIndex: index + (week * 7),
                          selectedDate: selectedDate,
                          date: widget.startingDate!.add(
                            Duration(
                              days: (index + (week * 7)),
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void changeDayCallback(int index) {
    setState(() {
      selectedDate = index;
    });
  }

  void handleChangeDay(int index) {
    setState(() {
      widget.pageController!.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
    });
  }
}

///
/// Contains the two designs (whether selected or not)
/// of the WeekDaysSliderDayButton.
///
class WeekDaysSliderDayButton extends StatelessWidget {
  WeekDaysSliderDayButton({
    required this.dayIndex,
    required this.selectedDate,
    required this.date,
  });

  final int dayIndex;
  final int selectedDate;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return selectedDate == dayIndex
        ? Container(
            width: width / 10,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: kMainColor.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Text('${date.day}',
                    style: GoogleFonts.montserrat(
                      color: kMainColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
                Text(
                  '${numToWeekday(date.weekday)}',
                  style: GoogleFonts.montserrat(
                    color: kMainColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          )
        : Container(
            width: width / 10,
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              children: [
                Text('${date.day}',
                    style: GoogleFonts.montserrat(
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
                Text(
                  '${numToWeekday(date.weekday)}',
                  style: GoogleFonts.montserrat(
                    color: kTextColor.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          );
  }

  String numToWeekday(num number) {
    switch (number % 7) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return number.toString();
    }
  }
}