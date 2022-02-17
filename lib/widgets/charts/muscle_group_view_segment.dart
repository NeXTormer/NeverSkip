import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/charts/muscle_group_split_piechart.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class MuscleGroupViewSegment extends StatelessWidget {
  const MuscleGroupViewSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            FredericHeading(
              tr('home.chart.title_muscle_group_volume'),
              subHeading: tr('home.chart.0month'),
            ),
            const SizedBox(height: 8),
            BlocBuilder<FredericSetManager, FredericSetListData>(
                builder: (context, data) {
              return FredericCard(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: MuscleGroupSplitPiechart(
                        arms: data.muscleSplit[1],
                        legs: data.muscleSplit[3],
                        chest: data.muscleSplit[0],
                        back: data.muscleSplit[2],
                        abs: data.muscleSplit[4],
                      ),
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
