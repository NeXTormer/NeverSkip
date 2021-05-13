import 'package:flutter/material.dart';
import 'package:frederic/widgets/home_screen/training_volume_chart_segment.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class HomeScreen extends StatelessWidget {
  static const double SIDE_PADDING = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          //HomeScreenAppbar(user!), //TODO NULL SAFETY
          SliverDivider(),
          //ProgressIndicatorSegment(user.progressMonitors),
          //GoalSegment(),
          TrainingVolumeChartSegment(),
          SliverToBoxAdapter(
            child: Container(height: 2000, color: Colors.white),
          ),
        ],
      )),
    );
  }
}
