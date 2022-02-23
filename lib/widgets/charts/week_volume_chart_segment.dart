import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/charts/frederic_chart.dart';
import 'package:frederic/widgets/charts/training_volume_week_chart_page.dart';

class WeekVolumeChartSegment extends StatelessWidget {
  const WeekVolumeChartSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child:
        BlocBuilder<FredericSetManager, FredericSetListData>(
            builder: (context, setListData) {
      List<int> volume = setListData.weeklyTrainingVolume;

      return FredericChart(
        height: 216,
        padding: const EdgeInsets.all(16),
        reversed: true,
        title: tr('home.chart.title_training_volume_week'),
        pages: [
          FredericChartPage(
              title: tr('home.chart.0week'),
              page: TrainingVolumeWeekChartPage(volume.sublist(21, 28))),
          FredericChartPage(
              title: tr('home.chart.1week'),
              page: TrainingVolumeWeekChartPage(volume.sublist(14, 21))),
          FredericChartPage(
              title: tr('home.chart.2week'),
              page: TrainingVolumeWeekChartPage(volume.sublist(7, 14))),
          FredericChartPage(
              title: tr('home.chart.3week'),
              page: TrainingVolumeWeekChartPage(volume.sublist(0, 7))),
        ],
      );
    }));
  }
}
