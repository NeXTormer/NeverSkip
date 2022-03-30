import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/onboarding_screen.dart';
import 'package:frederic/screens/start_trial_screen.dart';
import 'package:frederic/widgets/charts/month_volume_chart_segment.dart';
import 'package:frederic/widgets/charts/muscle_group_chart_segment.dart';
import 'package:frederic/widgets/charts/week_volume_chart_segment.dart';
import 'package:frederic/widgets/home_screen/achievement_segment.dart';
import 'package:frederic/widgets/home_screen/goal_segment.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/misc_stuff_segment.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    startupTimeProfiler?.stop();
    FredericBackend.instance.toastManager.removeLoginLoadingToast(context);
    super.initState();
    Future(() async {
      if (FredericBackend.instance.userManager.firstUserSignUp) {
        FredericBackend.instance.userManager.firstUserSignUp = false;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => OnboardingScreen()));
        CupertinoScaffold.showCupertinoModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context,
            builder: (ctx) => StartTrialScreen());
      }
      //if(FredericBackend.instance.userManager.firstUserSignUp == false && )
    });
  }

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              HomeScreenAppbar(user),
              ProgressIndicatorSegment(),
              GoalSegment(),
              MonthVolumeChartSegment(),
              MuscleGroupChartSegment(),
              WeekVolumeChartSegment(),
              AchievementSegment(),
              MiscStuffSegment(),
            ],
          );
        },
      ),
    );
  }
}
