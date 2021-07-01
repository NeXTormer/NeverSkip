import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekdaysSlider extends StatefulWidget {
  WeekdaysSlider(
      {this.weekCount = 1,
      required this.controller,
      required this.onSelectDay});

  final WeekdaySliderController? controller;
  final int weekCount;
  final Function(int)? onSelectDay;

  @override
  _WeekdaysSliderState createState() => _WeekdaysSliderState();
}

class _WeekdaysSliderState extends State<WeekdaysSlider> {
  PageController? pageController;
  int _currentDay = DateTime.now().day;

  int get currentDay => _currentDay;

  set currentDay(int value) {
    _currentDay = value;
    if (widget.controller != null) widget.controller!.currentDay = value;
  }

  @override
  void initState() {
    pageController = PageController();
    widget.controller?._setDayCallback = handleChangeDay;
    widget.controller?._setDayCallbackOnlyVisual = handleChangeDayVisual;
    widget.controller!.pageController = pageController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ExpandablePageView(
        animateFirstPage: true,
        itemCount: widget.weekCount,
        itemBuilder: (context, index) {
          return Padding(
            // TODO Somehow the widget is not centered,
            // so the paddings are not symmetrical
            padding: EdgeInsets.only(left: 15, right: 20),
            child: WeekdaysSliderPage(
                weekIndex: index,
                onSelectDay: handleChangeDay,
                currentDay: currentDay),
          );
        },
      ),
    );
  }

  void handleChangeDay(int day) {
    setState(() {
      currentDay = day;
      widget.controller!.onDayChange(day);
    });
  }

  void handleChangeDayVisual(int day) {
    setState(() {
      currentDay = day;
      int newpage = (day / 7).ceil() - 1;
      if (newpage != pageController!.page)
        pageController!.animateToPage(newpage,
            duration: Duration(milliseconds: 350), curve: Curves.easeInOutExpo);
    });
  }
}

class WeekdaysSliderPage extends StatelessWidget {
  WeekdaysSliderPage(
      {required this.weekIndex,
      required this.onSelectDay,
      required this.currentDay});

  final int currentDay;
  final int weekIndex;
  final Function(int) onSelectDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(
                7,
                (index) {
                  int day = (index + 1) + (weekIndex * 7);
                  return InkWell(
                      onTap: () => onSelectDay(day),
                      child: WeekdaySliderDayButton(
                        day,
                        currentDay: currentDay,
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeekdaySliderDayButton extends StatelessWidget {
  WeekdaySliderDayButton(this.number, {required this.currentDay});

  final int number;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return currentDay == number
        ? Container(
            width: width / 10,
            padding: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: kMainColor.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Text('$number',
                    style: GoogleFonts.montserrat(
                      color: kMainColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
                Text(
                  '${numToWeekday(number)}',
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
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Column(
              children: [
                Text('$number',
                    style: GoogleFonts.montserrat(
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
                Text(
                  '${numToWeekday(number)}',
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

class WeekdaySliderController {
  WeekdaySliderController({required this.onDayChange});

  late Function(int) _setDayCallback;
  late Function(int) _setDayCallbackOnlyVisual;
  final Function(int) onDayChange;

  PageController? pageController;

  int currentDay = 1;

  void setDay(int day) {
    _setDayCallback(day);
  }

  void setDayOnlyVisual(int day) {
    _setDayCallbackOnlyVisual(day);
  }
}
