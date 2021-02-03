import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/providers/progress_graph.dart';
import 'package:frederic/widgets/line_titles.dart';

class CardChartItem extends StatelessWidget {
  final ProgressGraphItem graph;

  CardChartItem(this.graph);

  List<FlSpot> convertToFlSpot(List<double> doubleArray) {
    List<FlSpot> output = [];
    for (int i = 0; i < doubleArray.length; i++) {
      output.add(FlSpot(i.toDouble(), doubleArray[i]));
    }
    return output;
  }

  List<LineChartBarData> graphLines(ProgressGraphItem graph) {
    List<LineChartBarData> output = [];
    for (int i = 0; i < graph.lines.length; i++) {
      output.add(LineChartBarData(
        spots: convertToFlSpot(graph.lines[i]),
        colors: [graph.legend[i].color],
        barWidth: 5.0,
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 200,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: 5,
          titlesData: LineTitles.getTitleData(),
          gridData: FlGridData(
            show: true,
          ),
          borderData: FlBorderData(
              show: true,
              border: Border.symmetric(
                  horizontal: BorderSide(width: 1.0, color: Colors.black12))),
          lineBarsData: [
            ...graphLines(graph),
          ],
        ),
      ),
    );
  }
}
