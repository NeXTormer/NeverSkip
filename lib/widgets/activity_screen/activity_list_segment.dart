import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';

import 'activity_filter_controller.dart';

class ActivityListSegment extends StatelessWidget {
  ActivityListSegment({required this.filterController});

  final ActivityFilterController filterController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericActivityManager, FredericActivityListData>(
      builder: (context, listData) {
        List<FredericActivity> list =
            listData.getFilteredActivities(filterController);
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ActivityCard(list[index],
                  onClick:
                      () {}); // TODO implement onClick function for adding to workout
            },
            childCount: list.length,
          ),
        );
      },
    );
  }
}
