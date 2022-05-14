import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:intl/intl.dart';

class FredericDatePicker extends StatefulWidget {
  FredericDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  final DateFormat df = DateFormat('MMMM');
  final DateTime initialDate;
  final void Function(DateTime) onDateChanged;

  @override
  _FredericDatePickerState createState() => _FredericDatePickerState();
}

class _FredericDatePickerState extends State<FredericDatePicker> {
  int selectedMonthIndex = 1;
  int selectedDayIndex = 0;
  DateTime today = DateTime.now();
  late DateTime startingDate;
  double dayWidth = 0;
  double dayPadding = 12;
  double dayTotalWidth = 0;

  ScrollController dayController = ScrollController(initialScrollOffset: -12);
  ScrollController monthController = ScrollController();

  @override
  void initState() {
    DateTime oneMonthBefore = today.subtract(Duration(days: today.day + 1));
    startingDate = DateTime(oneMonthBefore.year, oneMonthBefore.month, 1);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      jumpToDay(widget.initialDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dayWidth = (MediaQuery.of(context).size.width / 10);
    dayTotalWidth = dayPadding + dayWidth;
    return Container(
      color: theme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              height: 36,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: monthController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 12 : 0),
                        child: buildMonth(startingDate, -index, index,
                            index == selectedMonthIndex));
                  },
                  itemCount: 13),
            ),
            SizedBox(height: 16),
            Container(
              height: 50,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: dayController,
                scrollDirection: Axis.horizontal,
                itemCount: 365 + 30,
                itemBuilder: (context, index) {
                  int year = startingDate.year;
                  int month = startingDate.month;
                  int day = startingDate.day;

                  // Using this method instead of:
                  //    startingDate.add(Duration(days: index));
                  // because DateTime::add() takes daylight savings into
                  // consideration and we don't want that
                  DateTime date = DateTime(year, month, day + index);
                  return Container(
                    margin: EdgeInsets.only(left: index == 0 ? 12 : 0),
                    width: dayTotalWidth,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                          selectMonth(date);
                          widget.onDateChanged.call(date);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: theme.cardBorderColor, width: 0.6)),
                        child: FredericCard(
                          child: _WeekDaysSliderDayButton(
                              dayIndex: index,
                              selectedDate: selectedDayIndex,
                              date: date),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  void selectMonth(DateTime day) {
    int yearDiff = day.year - startingDate.year;
    int monthDiff = day.month - startingDate.month;
    int totalDiff = (yearDiff * 12) + monthDiff;
    selectedMonthIndex = totalDiff;
  }

  void jumpToDay(DateTime day) {
    int index = day.difference(startingDate).inDays;
    dayController.jumpTo((dayTotalWidth) * index);
    selectedDayIndex = index;
  }

  Widget buildMonth(DateTime today, int monthOffset, int index, bool selected) {
    int newMonth = today.month - monthOffset;
    int yearOffset = 0;
    if (newMonth < 1) {
      newMonth = newMonth % DateTime.monthsPerYear;
      yearOffset = -1;
    } else if (newMonth > 12) {
      newMonth = newMonth % DateTime.monthsPerYear;
      yearOffset = 1;
    }
    DateTime firstDayOfMonth = DateTime(today.year + yearOffset, newMonth, 1);
    String string = widget.df.format(firstDayOfMonth);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => setState(() {
          jumpToDay(firstDayOfMonth);
          selectedMonthIndex = index;
          widget.onDateChanged.call(firstDayOfMonth);
        }),
        child: Container(
          decoration: BoxDecoration(
              color: selected
                  ? theme.mainColorLight
                  : (theme.isDark ? theme.cardBackgroundColor : Colors.white),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.cardBorderColor)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Center(
            child: Text(string,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: selected ? theme.mainColorInText : theme.textColor)),
          ),
        ),
      ),
    );
  }

  Widget buildYear(String year) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.cardBorderColor)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Center(
          child: Text(year,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
        ),
      ),
    );
  }
}

///
/// Contains the two designs (whether selected or not)
/// of the WeekDaysSliderDayButton.
///
class _WeekDaysSliderDayButton extends StatelessWidget {
  _WeekDaysSliderDayButton(
      {required this.dayIndex,
      required this.selectedDate,
      required this.date,
      this.dayWidth});

  final int dayIndex;
  final int selectedDate;
  final DateTime date;
  final double? dayWidth;

  @override
  Widget build(BuildContext context) {
    var width = dayWidth ?? (MediaQuery.of(context).size.width / 10);
    return selectedDate == dayIndex
        ? Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: theme.mainColor.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${date.day}',
                    style: TextStyle(
                      color: theme.mainColorInText,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
                Text(
                  '${numToWeekday(date.weekday)}',
                  style: TextStyle(
                    color: theme.mainColorInText.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          )
        : Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: theme.cardBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${date.day}',
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
                Text(
                  '${numToWeekday(date.weekday)}',
                  style: TextStyle(
                    color: theme.textColor.withOpacity(0.8),
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
