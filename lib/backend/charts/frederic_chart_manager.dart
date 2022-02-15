import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/charts/chart_data_interface.dart';

class FredericChartManager extends Cubit<List<ChartDataInterface>> {
  FredericChartManager(List<ChartDataInterface> initialState)
      : super(initialState);

  final List<ChartDataInterface> charts = <ChartDataInterface>[];
}
