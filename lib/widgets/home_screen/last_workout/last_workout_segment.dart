import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frederic/widgets/home_screen/last_workout/last_workout_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class LastWorkoutSegment extends StatelessWidget {
  const LastWorkoutSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            FredericHeading(
              'Last workout',
              icon: Platform.isAndroid ? Icons.share_outlined : Icons.ios_share,
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            FredericCard(
              child: LastWorkoutCard(),
            )
          ],
        ),
      ),
    );
  }
}
