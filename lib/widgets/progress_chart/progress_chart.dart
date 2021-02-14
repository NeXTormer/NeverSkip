import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({Key key, @required this.chartData}) : super(key: key);

  final FredericChartData chartData;

  @override
  Widget build(BuildContext context) {
    Stream<FredericChartData> stream =
        chartData.asStream(FredericChartType.CurrentMonth);
    return StreamBuilder<FredericChartData>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    legend:
                        Legend(isVisible: true, position: LegendPosition.top),
                    tooltipBehavior: TooltipBehavior(
                        enable: true, activationMode: ActivationMode.singleTap),
                    series: <LineSeries<FredericChartDataPoint, String>>[
                  LineSeries<FredericChartDataPoint, String>(
                      dataSource: snapshot.data.data,
                      xValueMapper: (FredericChartDataPoint sales, _) =>
                          sales.date.toString(),
                      yValueMapper: (FredericChartDataPoint sales, _) =>
                          sales.value,
                      name: chartData.activity.name),
                ]));
          return Column(
              children: [SizedBox(height: 32), CircularProgressIndicator()]);
        });
  }
}
