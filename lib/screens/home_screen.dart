import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/analytics_service.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/home_screen/achievement_segment.dart';
import 'package:frederic/widgets/home_screen/goal_segment.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';
import 'package:frederic/widgets/home_screen/training_volume_chart_segment.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnalyticsService _analyticsService = getIt<AnalyticsService>();

  @override
  void initState() {
    _analyticsService.setUserProperties(
        userID: FirebaseAuth.instance.currentUser?.uid ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) {
          return CustomScrollView(
            slivers: [
              HomeScreenAppbar(user),
              SliverDivider(),
              ProgressIndicatorSegment(),
              GoalSegment(),
              TrainingVolumeChartSegment(),
              AchievementSegment(),
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
