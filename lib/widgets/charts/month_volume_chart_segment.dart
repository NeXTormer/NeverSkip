import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/charts/frederic_chart.dart';
import 'package:frederic/widgets/charts/month_volume_chart_page.dart';

class MonthVolumeChartSegment extends StatelessWidget {
  const MonthVolumeChartSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child:
        BlocBuilder<FredericSetManager, FredericSetListData>(
            builder: (context, setListData) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FredericChart(
          title: tr('home.chart.title_activity_of_last_year'),
          pages: [
            FredericChartPage(
                title: null,
                page: MonthVolumeChartPage(
                  setListData: setListData,
                ))
          ],
        ),
      );
    }));
  }
}
