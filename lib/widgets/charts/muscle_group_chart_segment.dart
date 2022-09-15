import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/charts/frederic_chart.dart';
import 'package:frederic/widgets/charts/muscle_group_split_piechart.dart';

class MuscleGroupChartSegment extends StatelessWidget {
  const MuscleGroupChartSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child:
        BlocBuilder<FredericSetManager, FredericSetListData>(
            builder: (context, data) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FredericChart(
            height: 216,
            title: tr('home.chart.title_muscle_group_volume'),
            pages: [
              FredericChartPage(
                title: tr('home.chart.0month'),
                page: MuscleGroupSplitPiechart(
                  chest: data.muscleSplit[0],
                  arms: data.muscleSplit[1],
                  back: data.muscleSplit[2],
                  legs: data.muscleSplit[3],
                  abs: data.muscleSplit[4],
                ),
              ),
            ]),
      );
    }));
  }
}
