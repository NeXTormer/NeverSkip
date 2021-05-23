import 'package:flutter/material.dart';
import 'package:frederic/widgets/activity_screen/activity_list_card.dart';
import 'package:frederic/widgets/standard_elements/activity_card.dart';

import '../../backend/frederic_activity.dart';
import '../../backend/frederic_activity_builder.dart';
import 'activity_filter_controller.dart';

class ActivityListSegment extends StatelessWidget {
  ActivityListSegment({required this.filterController});

  final ActivityFilterController filterController;

  @override
  Widget build(BuildContext context) {
    return FredericActivityBuilder(
      type: FredericActivityBuilderType.AllActivities,
      builder: (context, list) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              FredericActivity activity = list[index];
              if (activity.matchFilterController(filterController)) {
                return ActivityListCard(activity,
                    onClick:
                        () {}); // TODO implement onClick function for adding to workout
              }
              return Container();
            },
            childCount: list.length,
          ),
        );
      },
    );
  }
}
