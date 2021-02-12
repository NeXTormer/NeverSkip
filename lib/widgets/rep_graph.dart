import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:frederic/widgets/line_titles.dart';

class RepGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 7,
          minY: 0,
          maxY: 6,
          titlesData: LineTitles.getTitleData(),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.black54,
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.blue,
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 2),
                FlSpot(2, 2),
                FlSpot(3, 5),
              ],
              isCurved: true,
              // dotData: FlDotData(show: false),
              colors: [Colors.red, Colors.red[200]],
              barWidth: 5,
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(3, 4),
              ],
              isCurved: true,
              // dotData: FlDotData(show: false),
              colors: [Colors.blue, Colors.blue[200]],
              barWidth: 5,
            )
          ],
        ),
      ),
    );
  }
}
