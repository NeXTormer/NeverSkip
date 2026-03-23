import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/onboarding_screen.dart';
import 'package:frederic/screens/start_trial_screen.dart';
import 'package:frederic/widgets/charts/activity_heatmap_chart_segment.dart';
import 'package:frederic/widgets/charts/muscle_group_chart_segment.dart';
import 'package:frederic/widgets/charts/progress_chart_segment.dart';
import 'package:frederic/widgets/charts/week_volume_chart_segment.dart';
import 'package:frederic/widgets/home_screen/achievement_segment.dart';
import 'package:frederic/widgets/home_screen/goal_segment.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/last_workout/last_workout_segment.dart';
import 'package:frederic/widgets/home_screen/misc_stuff_segment.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';

import 'package:frederic/services/watch_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WatchService _watchService = WatchService();

  @override
  void initState() {
    _watchService.onDataReceived = (data) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Received from Watch: ${data['response']}")),
      );
    };
    
    // Sync data to watch and pull any pending offline sets
    _watchService.syncCalendarToWatch();
    _watchService.getPendingSets();

    startupTimeProfiler?.stop();
    FredericBackend.instance.toastManager.removeLoginLoadingToast(context);
    Future(() async {
      if (FredericBackend.instance.userManager.state.id.isEmpty) {
        FredericProfiler.log(
            "=====SHOULD NOT HAPPEN===== Showing homescreen with no user doc");
      }

      if (FredericBackend.instance.userManager.firstUserSignUp) {
        FredericBackend.instance.userManager.firstUserSignUp = false;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => OnboardingScreen()));
      }
      if (!FredericBackend.instance.userManager.state.trialStarted &&
          !FredericBackend.instance.userManager.state.canUseApp) {
        showFredericBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context,
            builder: (ctx) => StartTrialScreen());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _watchService.syncCalendarToWatch();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Syncing today\'s workout to Apple Watch...')),
          );
        },
        child: Icon(Icons.sync),
        backgroundColor: theme.mainColor,
      ),
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              HomeScreenAppbar(user),
              ProgressIndicatorSegment(),
              GoalSegment(),
              LastWorkoutSegment(),
              ActivityHeatmapChartSegment(),
              if (false) ProgressChartSegment(),
              MuscleGroupChartSegment(),
              WeekVolumeChartSegment(),
              AchievementSegment(),
              MiscStuffSegment(),
              // Adding some bottom padding to avoid FAB overlap
              SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    );
  }
}
