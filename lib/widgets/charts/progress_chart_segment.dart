import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/charts/frederic_chart.dart';
import 'package:frederic/widgets/charts/progress_line_chart.dart';

class ProgressChartSegment extends StatelessWidget {
  const ProgressChartSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child:
        BlocBuilder<FredericSetManager, FredericSetListData>(
            builder: (context, data) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FredericChart(
            height: 216,
            title: tr('home.chart.title_progress_chart'),
            pages: [
              FredericChartPage(
                  title: 'Coming soon...',
                  page: ProgressLineChart(<FredericSet>[]))
            ]),
      );
    }));
  }
}
