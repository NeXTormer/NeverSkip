import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';

class ProgressLineChart extends StatelessWidget {
  ProgressLineChart(
      {required this.timeSeriesData,
      required this.activity,
      this.months = 12,
      Key? key})
      : super(key: key) {}

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final FredericActivity activity;
  final HashMap<String, List<double?>> timeSeriesData;
  final int months;
  final bool isStepLineChart = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
      child: LineChart(mainData()),
    );
  }

  LineChartData mainData() {
    final List<FlSpot> chartData = <FlSpot>[];

    final list = timeSeriesData['NPZDVAhfqtapwXHHIRul'];
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i] != null) {
          chartData.add(FlSpot(i.toDouble(), list[i]!));
        }
      }
    }

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.disabledGreyColor,
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: theme.disabledGreyColor,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        // show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 16,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 24,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: theme.disabledGreyColor, width: 1)),
      minX: chartData.first.x,
      maxX: chartData.last.x,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: false,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 4,
          isStrokeJoinRound: true,
          isStepLineChart: isStepLineChart,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors:
                    gradientColors.map((e) => e.withOpacity(0.15)).toList()),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('MAR', style: style);
        break;
      case 2:
        text = const Text('JUN', style: style);
        break;
      case 11:
        text = const Text('Sep', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
      space: 2,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}

// class _ProgressLineChartState extends State<ProgressLineChart> {
//
//
//
//   void initState() {
//     super.initState();
//   }
//
//   // //TODO: also move this to SetTimeSeriesDataRepresentation
//   // void initData() {
//   //   chartData.clear();
//   //   final now = DateTime.now();
//   //   final end = DateTime(now.year, now.month, now.day + 1);
//   //
//   //   int startMonth = now.month - widget.months;
//   //   int startYear = now.year;
//   //   while (startMonth < 1) {
//   //     startMonth += 12;
//   //     startYear -= 1;
//   //   }
//   //   print("StartMonth: $startMonth, startYear: $startYear");
//   //
//   //   final start = DateTime(startYear, startMonth, now.day);
//   //   DateTime current = start;
//   //   print("Start");
//   //   int dayIndex = 0;
//   //   while (current.isBefore(end)) {
//   //     final TimeSeriesSetData? data = widget
//   //         .timeSeriesData[DateTime(current.year, current.month, current.day)];
//   //
//   //     if (data != null) {
//   //       FredericSet? set = data.bestSetOnDay['NPZDVAhfqtapwXHHIRul'];
//   //
//   //       if (set != null) {
//   //         chartData.add(FlSpot(dayIndex.toDouble(), set.weight));
//   //         print('${dayIndex}: ${set.weight}');
//   //       }
//   //     }
//   //
//   //     current = current.add(const Duration(days: 1));
//   //     dayIndex++;
//   //   }
//   //   print("END");
//   //   print("END");
//   //   print("END");
//   // }
//
//
// }
