import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/widgets/history_screen/history_set_card.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';

class HistoryActivityCard extends StatelessWidget {
  const HistoryActivityCard(
      {required this.activity, required this.sets, Key? key})
      : super(key: key);

  final FredericActivity activity;
  final List<FredericSet> sets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActivityCard(
          activity,
          onClick: () {},
          onLongPress: () {},
        ),
        for (final set in sets)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: HistorySetCard(set: set),
          )
      ],
    );
  }
}
