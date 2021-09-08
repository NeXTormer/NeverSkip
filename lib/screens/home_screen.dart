import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/home_screen/goal_segment.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';
import 'package:frederic/widgets/home_screen/training_volume_chart_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              HomeScreenAppbar(user),
              if (theme.isBright) SliverDivider(),
              ProgressIndicatorSegment(),
              GoalSegment(),
              TrainingVolumeChartSegment(),
            ],
          );
        },
        buildWhen: (previous, current) {
          return current.finishedLoading;
        },
      ),
    );
  }
}
