import 'package:flutter/material.dart';
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
              'Muscle Group Split',
              subHeading: 'Last 7 Days',
            ),
            const SizedBox(height: 8),
            FredericCard(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: MuscleGroupSplitPiechart(
                      arms: 1,
                      legs: 2,
                      chest: 1,
                      back: 2,
                      abs: 0.1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
