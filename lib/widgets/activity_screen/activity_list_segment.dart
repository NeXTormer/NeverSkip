import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';

import '../../state/activity_filter_controller.dart';

class ActivityListSegment extends StatelessWidget {
  ActivityListSegment(
      {required this.filterController,
      this.onTap,
      this.onLongPress,
      this.isSelector = false});

  final ActivityFilterController filterController;
  final void Function(FredericActivity)? onTap;
  final void Function(FredericActivity)? onLongPress;

  final bool isSelector;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericActivityManager, FredericActivityListData>(
      builder: (context, listData) {
        List<FredericActivity> list =
            listData.getFilteredActivities(filterController);
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ActivityCard(
                  list[index],
                  addProgressOnLongPress: isSelector,
                  onClick:
                      onTap == null ? null : () => onTap?.call(list[index]),
                  onLongPress: onLongPress == null
                      ? null
                      : () => onLongPress?.call(list[index]),
                ),
              );
            },
            childCount: list.length,
          ),
        );
      },
    );
  }
}
