import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';
import 'package:frederic/widgets/home_screen/training_volume_chart_segment.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class HomeScreen extends StatelessWidget {
  static const double SIDE_PADDING = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) {
          return CustomScrollView(
            slivers: [
              HomeScreenAppbar(user), //TODO NULL SAFETY
              SliverDivider(),
              //SliverToBoxAdapter(child: Text(user.uid)),
              //SliverToBoxAdapter(child: Text(user.name)),
              ProgressIndicatorSegment(),
              //GoalSegment(),
              TrainingVolumeChartSegment(),
              SliverToBoxAdapter(
                child: Container(height: 2000, color: Colors.white),
              ),
            ],
          );
        },
        buildWhen: (previous, current) {
          return current.finishedLoading;
        },
      )),
    );
  }
}
