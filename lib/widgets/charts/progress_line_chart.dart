import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/main.dart';

class ProgressLineChart extends StatelessWidget {
  ProgressLineChart(this.sets, {Key? key}) : super(key: key);

  // final List<Color> gradientColors = [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];

  final List<FredericSet> sets;

  final List<Color> gradientColors = [
    theme.mainColor,
    theme.accentColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: LineChart(mainData()),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.disabledGreyColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: theme.disabledGreyColor,
            strokeWidth: 1,
          );
        },
      ),
      /*
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: false,
          reservedSize: 12,
          interval: 1,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          interval: 1,
          reservedSize: 12,
        ),
      ),
       */
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: theme.disabledGreyColor, width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: //sets.map((e) => FlSpot(e.weight, e.timestamp)).toList(),
              const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors: gradientColors.map((e) => e.withOpacity(0.2)).toList()),
          ),
        ),
      ],
    );
  }
}
