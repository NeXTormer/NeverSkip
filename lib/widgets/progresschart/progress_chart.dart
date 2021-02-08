import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Half yearly sales analysis'),
            // Enable legend
            legend: Legend(isVisible: true, position: LegendPosition.top),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(
                enable: true, activationMode: ActivationMode.singleTap),
            series: <LineSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
            dataSource: <SalesData>[
              SalesData('Jan', 35),
              SalesData('Feb', 28),
              SalesData('Mar', 34),
              SalesData('Apr', 32),
              SalesData('May', 40)
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ]));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
