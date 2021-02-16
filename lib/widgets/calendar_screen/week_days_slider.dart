import 'package:flutter/material.dart';

class WeekDaysSlide extends StatefulWidget {
  final int weekCount;
  final Function updateSelectedDay;
  final int selectedDay;
  WeekDaysSlide(this.weekCount, this.updateSelectedDay, this.selectedDay);

  @override
  _WeekDaysSlideState createState() => _WeekDaysSlideState();
}

class _WeekDaysSlideState extends State<WeekDaysSlide> {
  @override
  Widget build(BuildContext context) {
    final int _scaledDay = 1 + widget.weekCount * 7;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Week ${widget.weekCount + 1}',
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
                  return InkWell(
                    onTap: () {
                      widget.updateSelectedDay(index + _scaledDay);
                    },
                    child: widget.selectedDay == (index + _scaledDay)
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
                                    '${index + 1 + widget.weekCount * 7}',
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
                                  '${index + 1 + widget.weekCount * 7}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Divider(),
        ],
      ),
    );
  }
}
