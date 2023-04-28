import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';

class ProgressLineChart extends StatelessWidget {
  ProgressLineChart(
      {required this.timeSeriesData,
      required this.activity,
      this.months = 12,
      Key? key})
      : calculatedChartData = <FlSpot>[],
        super(key: key);

  final List<Color> gradientColors = [theme.mainColor, theme.accentColor];

  final FredericActivity activity;
  final HashMap<String, List<double?>> timeSeriesData;
  final int months;
  final bool isStepLineChart = false;

  final List<FlSpot> calculatedChartData;
  double maxValue = 0;
  double minValue = double.infinity;
  int firstIndex = 99999999999;
  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: theme.greyTextColor,
    );

    calculateChartData();
    if (calculatedChartData.isEmpty) {
      return Center(
        child: Text(
          'No data for the selected exercise',
          style: TextStyle(color: theme.greyTextColor),
        ),
      );
    }

    double timeTitleInterval = 1;
    int timeDifference = lastIndex - firstIndex;
    int timeTitleCount = 3;
    timeTitleInterval = timeDifference / timeTitleCount;
    assert(timeDifference > 0);

    double maxDisplayedValue = maxValue + (10 - (maxValue % 10));

    double progressTitleCount = 5;
    double progressTitleInterval = maxDisplayedValue / progressTitleCount;

    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 4),
      child: Column(
        children: [
          Expanded(
            child: LineChart(LineChartData(
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
                    showTitles: false,
                    reservedSize: 16,
                    interval: timeTitleInterval,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: progressTitleInterval,
                    getTitlesWidget: leftTitleWidgets,
                    reservedSize: 24,
                  ),
                ),
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: theme.disabledGreyColor, width: 1)),
              minX: calculatedChartData.first.x,
              maxX: calculatedChartData.last.x,
              minY: 0,
              maxY: maxDisplayedValue,
              lineBarsData: [
                LineChartBarData(
                  spots: calculatedChartData,
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
                        colors: gradientColors
                            .map((e) => e.withOpacity(0.15))
                            .toList()),
                  ),
                ),
              ],
            )),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 24),
              Text("Jan 2022", style: titleStyle),
              Expanded(child: Container()),
              Text("today", style: titleStyle),
            ],
          )
        ],
      ),
    );
  }

  void calculateChartData() {
    calculatedChartData.clear();
    final list = timeSeriesData[activity.id];

    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i] != null) {
          calculatedChartData.add(FlSpot(i.toDouble(), list[i]!));
          if (i < firstIndex) firstIndex = i;
          if (i > lastIndex) lastIndex = i;
          if (list[i]! > maxValue) maxValue = list[i]!;
          if (list[i]! < minValue) minValue = list[i]!;
        }
      }
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: theme.greyTextColor,
    );
    final date = DateTime.now().subtract(Duration(days: value.toInt()));
    String text = '${date.year}-${date.month}-${date.day}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
      space: 2,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: theme.greyTextColor,
    );
    String text = '${value.toInt()} ${activity.progressUnit}';

    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style, textAlign: TextAlign.left));
  }
}
