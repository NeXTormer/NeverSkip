import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/edit_workout_screen/weekdays_slider_segment.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:intl/intl.dart';

class FredericDatePicker extends StatefulWidget {
  FredericDatePicker({Key? key, required this.initialDate}) : super(key: key);

  final DateFormat df = DateFormat('MMMM');
  final DateTime initialDate;

  @override
  _FredericDatePickerState createState() => _FredericDatePickerState();
}

class _FredericDatePickerState extends State<FredericDatePicker> {
  int selectedMonthIndex = 1;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            height: 36,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 12 : 0),
                      child: buildMonth(today, -index + 1, index,
                          index == selectedMonthIndex));
                },
                itemCount: 13),
          ),
          SizedBox(height: 16),
          Container(
            height: 50,
            child: InfiniteListView.builder(
              physics: BouncingScrollPhysics(),
              controller: InfiniteScrollController(initialScrollOffset: -12),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kCardBorderColor, width: 0.6)),
                  child: WeekDaysSliderDayButton(
                      dayIndex: index,
                      selectedDate: 10,
                      date: widget.initialDate.add(Duration(days: index))),
                );
              },
            ),
          ),
        ],
      ),
    );
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
    String string = widget.df.format(DateTime(today.year, newMonth, 1));
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => setState(() => selectedMonthIndex = index),
        child: Container(
          decoration: BoxDecoration(
              color: selected ? kMainColorLight : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kCardBorderColor)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Center(
            child: Text(string,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: selected ? kMainColor : Colors.black)),
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
            border: Border.all(color: kCardBorderColor)),
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
