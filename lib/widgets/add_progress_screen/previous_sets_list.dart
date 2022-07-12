import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/extensions.dart';
import 'package:frederic/widgets/standard_elements/set_card.dart';

class PreviousSetsList extends StatelessWidget {
  const PreviousSetsList({required this.sets, required this.activity, Key? key})
      : super(key: key);

  final List<FredericSet> sets;
  final FredericActivity activity;

  @override
  Widget build(BuildContext context) {
    DateTime? currentDay;

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      double padding = 0;
      if (currentDay == null) currentDay = sets[index].timestamp;
      if (currentDay != null &&
          sets[index].timestamp.isNotSameDay(currentDay)) {
        currentDay = sets[index].timestamp;
        padding = 16;
      }

      return Padding(
        padding: EdgeInsets.only(top: padding),
        child: SetCard(sets[index], activity, greenIfToday: true),
      );
    }, childCount: sets.length));
  }
}
