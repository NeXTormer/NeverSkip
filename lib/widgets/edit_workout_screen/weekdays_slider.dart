import 'package:flutter/material.dart';

class WeekdaysSlider extends StatefulWidget {
  WeekdaysSlider(
      {this.weekCount = 1,
      @required this.controller,
      @required this.onSelectDay});

  final WeekdaySliderController controller;
  final int weekCount;
  final Function(int) onSelectDay;

  @override
  _WeekdaysSliderState createState() => _WeekdaysSliderState();
}

class _WeekdaysSliderState extends State<WeekdaysSlider> {
  PageController pageController;
  int currentDay = 1;

  @override
  void initState() {
    pageController = PageController();
    widget.controller?._setDayCallback = handleChangeDay;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: PageView(
        controller: pageController,
        children: List.generate(
            widget.weekCount,
            (index) => WeekdaysSliderPage(
                weekIndex: index,
                onSelectDay: handleChangeDay,
                currentDay: currentDay)),
      ),
    );
  }

  void handleChangeDay(int day) {
    setState(() {
      currentDay = day;
    });
  }
}

class WeekdaysSliderPage extends StatelessWidget {
  WeekdaysSliderPage(
      {@required this.weekIndex,
      @required this.onSelectDay,
      @required this.currentDay});

  final int currentDay;
  final int weekIndex;
  final Function(int) onSelectDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Week ${weekIndex + 1}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
  WeekdaySliderDayButton(this.number, {@required this.currentDay});

  final int number;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    return currentDay == number
        ? Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                left: 1,
                right: 1,
                bottom: -5.0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent[400],
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Day',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$number',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container(
            child: Column(
              children: [
                Text(
                  'Day',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          );
  }
}

class WeekdaySliderController {
  Function(int) _setDayCallback;

  void setDay(int day) {
    _setDayCallback(day);
  }
}
