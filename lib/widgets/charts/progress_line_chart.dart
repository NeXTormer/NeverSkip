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
      : calculatedChartData = <FlSpot>[],
        super(key: key) {}

  final List<Color> gradientColors = [theme.mainColor, theme.accentColor];

  final FredericActivity activity;
  final HashMap<String, List<double?>> timeSeriesData;
  final int months;
  final bool isStepLineChart = false;

  final List<FlSpot> calculatedChartData;

  @override
  Widget build(BuildContext context) {
    calculateChartData();
    if (calculatedChartData.isEmpty) {
      return Center(
        child: Text(
          'No data for the selected exercise',
          style: TextStyle(color: theme.greyTextColor),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
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
        minX: calculatedChartData.first.x,
        maxX: calculatedChartData.last.x,
        minY: 0,
        maxY: 100,
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
                  colors:
                      gradientColors.map((e) => e.withOpacity(0.15)).toList()),
            ),
          ),
        ],
      )),
    );
  }

  void calculateChartData() {
    calculatedChartData.clear();
    final list = timeSeriesData['NPZDVAhfqtapwXHHIRul'];

    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i] != null) {
          calculatedChartData.add(FlSpot(i.toDouble(), list[i]!));
        }
      }
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
    String text = '$value';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
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
