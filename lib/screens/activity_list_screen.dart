import 'package:flutter/material.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_segment.dart';
import 'package:frederic/widgets/activity_screen/activity_header.dart';
import 'package:frederic/widgets/activity_screen/activity_list_segment.dart';
import 'package:frederic/widgets/activity_screen/featured_activity_segment.dart';
import 'package:provider/provider.dart';

import '../backend/frederic_user_builder.dart';
import '../widgets/activity_screen/activity_filter_controller.dart';
import '../widgets/standard_elements/sliver_divider.dart';

class ActivityListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityFilterController>(
      create: (context) => ActivityFilterController(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FredericUserBuilder(
            builder: (context, user) {
              return Consumer<ActivityFilterController>(
                builder: (context, filter, child) {
                  return CustomScrollView(
                    slivers: [
                      ActivityHeader(),
                      SliverDivider(),
                      FeaturedActivitySegment(
                          'Featured',
                          user!
                              .progressMonitors), // TODO get list of user specific 'featured activities'
                      FeaturedActivitySegment('Calisthenics',
                          user.progressMonitors), // TODO get list of user? specific 'calisthenics activites'
                      ActivityFilterSegment(filterController: filter),
                      ActivityListSegment(filterController: filter),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
