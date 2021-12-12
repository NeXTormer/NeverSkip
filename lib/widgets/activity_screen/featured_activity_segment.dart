import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';

import '../../backend/backend.dart';
import '../standard_elements/frederic_heading.dart';

class FeaturedActivitySegment extends StatelessWidget {
  FeaturedActivitySegment(this.label, this.featuredActivities,
      {this.isSelector = false, this.onTap});

  final String label;
  final List<String> featuredActivities;
  final void Function(FredericActivity)? onTap;
  final bool isSelector;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: FredericHeading(
              label,
            ),
          ),
          BlocBuilder<FredericActivityManager, FredericActivityListData>(
            buildWhen: (current, next) => true,
            builder: (context, data) {
              List<FredericActivity> activityList = List.of(
                  data.activities.values.where((element) =>
                      featuredActivities.contains(element.activityID)));
              return BlocBuilder<FredericSetManager, FredericSetListData>(
                  buildWhen: (current, next) {
                return next.changedActivities
                    .any((element) => featuredActivities.contains(element));
              }, builder: (context, setListData) {
                return Container(
                  height: 60,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: activityList.length,
                    itemBuilder: (context, index) {
                      FredericSetList setList =
                          setListData[activityList[index].activityID];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 12,
                          right: index == (activityList.length - 1) ? 16 : 0,
                        ),
                        child: ActivityCard(activityList[index],
                            setList: setList,
                            onClick: onTap == null
                                ? null
                                : () => onTap?.call(activityList[index]),
                            type: ActivityCardType.Small),
                      );
                    },
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
