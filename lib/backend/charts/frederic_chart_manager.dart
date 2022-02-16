import 'package:flutter_bloc/flutter_bloc.dart';

import 'frederic_chart_data.dart';

class FredericChartManager extends Cubit<FredericChartList> {
  FredericChartManager() : super(FredericChartList());

  final Map<String, FredericChartData> _charts = <String, FredericChartData>{};

  void initialize() {}
}

class FredericChartList {
  final Map<String, FredericChartData> charts = <String, FredericChartData>{};
  final List<String> changed = <String>[];
}
