import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/small_activity_card_content.dart';

import '../../backend/backend.dart';
import '../standard_elements/frederic_heading.dart';

class FeaturedActivitySegment extends StatelessWidget {
  FeaturedActivitySegment(this.label, this.featuredActivities);

  final String label;
  final List<String> featuredActivities;

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
              onPressed: () {},
            ),
          ),
          BlocBuilder<FredericActivityManager, FredericActivityListData>(
            buildWhen: (current, next) => true,
            builder: (context, data) {
              List<FredericActivity> list = List.of(data.activities.values
                  .where((element) =>
                      featuredActivities.contains(element.activityID)));
              return Container(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    // TODO Padding on scrolling
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 16 : 12,
                        right: index == (list.length - 1) ? 16 : 0,
                      ),
                      child: SmallActivityCardContent(list[index]),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
