import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/set_time_series_data_representation.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/main.dart';

class ProgressLineChart extends StatefulWidget {
  ProgressLineChart(
      {required this.timeSeriesData,
      required this.activity,
      this.months = 3,
      Key? key})
      : super(key: key) {}

  // final List<Color> gradientColors = [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];

  final FredericActivity activity;
  final HashMap<DateTime, TimeSeriesSetData> timeSeriesData;
  final int months;

  @override
  State<ProgressLineChart> createState() => _ProgressLineChartState();
}

class _ProgressLineChartState extends State<ProgressLineChart> {
  final List<FlSpot> chartData = <FlSpot>[];

  final List<Color> gradientColors = [
    theme.mainColor,
    theme.accentColor,
  ];

  void initState() {
    super.initState();
    var profiler = FredericProfiler.track('ProgressLineChart initData');
    initData();
    profiler.stop();
  }

  //TODO: also move this to SetTimeSeriesDataRepresentation
  void initData() {
    chartData.clear();
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day + 1);

    int startMonth = now.month - widget.months;
    int startYear = now.year;
    while (startMonth < 1) {
      startMonth += 12;
      startYear -= 1;
    }

    final start = DateTime(startYear, startMonth, now.day);
    DateTime current = start;
    print("Start");
    int dayIndex = 0;
    while (current.isBefore(end)) {
      final TimeSeriesSetData? data = widget
          .timeSeriesData[DateTime(current.year, current.month, current.day)];

      if (data != null) {
        FredericSet? set = data.bestSetOnDay['wFoYDrwnV8zDzXFuOlwF'];
        // FredericSet? set =
        //     data.allSetsOnDay['wFoYDrwnV8zDzXFuOlwF']?.isEmpty ?? true
        //         ? null
        //         : data.allSetsOnDay['wFoYDrwnV8zDzXFuOlwF']?.first;
        if (set != null) {
          chartData.add(FlSpot(dayIndex.toDouble(), set.weight));
        }
      }

      current = current.add(const Duration(days: 1));
      dayIndex++;
    }
    print("END");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
      child: LineChart(mainData()),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        // show: true,
        // drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
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
          //     const [
          //   FlSpot(0, 3),
          //   FlSpot(2.6, 2),
          //   FlSpot(4.9, 5),
          //   FlSpot(6.8, 3.1),
          //   FlSpot(8, 4),
          //   FlSpot(9.5, 3),
          //   FlSpot(11, 4),
          // ],
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
