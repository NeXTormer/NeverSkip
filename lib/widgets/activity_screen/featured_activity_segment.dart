import 'package:flutter/material.dart';
import 'package:frederic/widgets/activity_screen/frederic_recommended_activity.dart';

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
          FutureBuilder<void>(
            future: FredericBackend.instance()!.activityManager!.hasData(),
            builder: (context, snapshot) {
              bool finished =
                  (snapshot.connectionState == ConnectionState.done);
              int length = featuredActivities.length;
              return Container(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: finished ? length : 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 16 : 12,
                        right: index == (length - 1) ? 16 : 0,
                      ),
                      child: FredericRecommendedActivity(
                        finished ? featuredActivities[index] : '0',
                        loading: !finished,
                      ),
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
