import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/screens/onboarding_screen.dart';
import 'package:frederic/widgets/home_screen/achievement_segment.dart';
import 'package:frederic/widgets/home_screen/goal_segment.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';
import 'package:frederic/widgets/home_screen/training_volume_chart_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FredericBackend.instance.toastManager.removeLoginLoadingToast(context);
    super.initState();
    Future(() async {
      if (FredericBackend.instance.userManager.firstUserSignUp) {
        FredericBackend.instance.userManager.firstUserSignUp = false;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => OnboardingScreen()));
      }
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
              TrainingVolumeChartSegment(),
              AchievementSegment(),
            ],
          );
        },
      ),
    );
  }
}
