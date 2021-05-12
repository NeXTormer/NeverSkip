import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class ProgressIndicatorSegment extends StatelessWidget {
  ProgressIndicatorSegment(this.progressMonitors, {this.sidePadding = 16});

  final double sidePadding;
  final List<String> progressMonitors;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 8),
          child: FredericHeading('Best stats', onPressed: () {}),
        ),
        FutureBuilder<void>(
            future: FredericBackend.instance!.activityManager!.hasData(),
            builder: (context, snapshot) {
              bool finished =
                  (snapshot.connectionState == ConnectionState.done);
              int count = progressMonitors.length;

              return Container(
                height: 60,
                child: ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: finished ? count : 2,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 16 : 12,
                            right: index == (count - 1) ? 16 : 0),
                        child: ProgressIndicatorCard(
                          finished ? progressMonitors[index] : '0',
                          loading: !finished,
                        ),
                      );
                    }),
              );
            })
      ],
    ));
  }
}
