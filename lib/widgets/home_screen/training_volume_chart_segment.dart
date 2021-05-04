import 'package:flutter/material.dart';
import 'package:frederic/widgets/frederic_card.dart';
import 'package:frederic/widgets/frederic_heading.dart';
import 'package:frederic/widgets/progress_bar.dart';

class TrainingVolumeChartSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<double> volume = [100, 300, 400, 800, 50, 200, 200];

    double highest = 0;
    double lowest = 0;
    for (double data in volume) {
      if (data > highest) highest = data;
    }
    highest += (100 - (highest % 100));
    double midhigh = (highest / 3) * 2;
    double midlow = highest / 3;

    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 22, bottom: 8),
          child: FredericHeading('This Week\'s Activity',
              subHeading: 'training volume', onPressed: () {}),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: FredericCard(
            height: 216,
            padding: EdgeInsets.all(16),
            child: Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildIndexText(highest),
                      buildIndexText(midhigh),
                      buildIndexText(midlow),
                      buildIndexText(lowest),
                    ],
                  ),
                ),
                buildWeekBar('Mon', volume[0] / highest, 0),
                buildWeekBar('Tue', volume[1] / highest, 1),
                buildWeekBar('Wed', volume[2] / highest, 2),
                buildWeekBar('Thu', volume[3] / highest, 3),
                buildWeekBar('Fri', volume[4] / highest, 4),
                buildWeekBar('Sat', volume[5] / highest, 5),
                buildWeekBar('Sun', volume[6] / highest, 6),
              ],
            )),
          ),
        )
      ],
    ));
  }

  Widget buildIndexText(double index) {
    return Text(
      '${index.truncate()}',
      style: const TextStyle(
          color: const Color(0x7A3A3A3A), fontSize: 11, letterSpacing: 0.3),
    );
  }

  Widget buildWeekBar(String day, double value, int index) {
    return Expanded(
      child: Column(
        children: [
          ProgressBar(
            value,
            vertical: true,
            length: 160,
            thickness: 10,
            alternateColor: index % 2 == 1,
          ),
          SizedBox(height: 10),
          Text(
            day,
            style: const TextStyle(
                color: const Color(0x7A3A3A3A),
                fontSize: 10,
                letterSpacing: 0.4),
          )
        ],
      ),
    );
  }
}
