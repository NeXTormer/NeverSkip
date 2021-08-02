import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/home_screen/goal_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class GoalSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 22, bottom: 8),
          child: FredericHeading('My goals', onPressed: () {}),
        ),
        Container(
          height: 70,
          child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 12,
                      right: index == ([1].length - 1) ? 16 : 0),
                  child: GoalCard(FredericGoal('s')),
                );
              }),
        )
      ],
    ));
  }
}
