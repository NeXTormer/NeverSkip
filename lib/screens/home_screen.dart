import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_chart_data.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_user_builder.dart';
import 'package:frederic/widgets/profile_screen/achievement_page.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_page.dart';
import 'package:frederic/widgets/profile_screen/profile_header.dart';
import 'package:frederic/widgets/profile_screen/small_progress_view_page.dart';
import 'package:frederic/widgets/progress_chart/progress_chart.dart';

import '../backend/backend.dart';

enum AddOptions {
  Goal,
  Graph,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FredericUserBuilder(
      builder: (context, user) => SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                // contains profile header
                color: Colors.white,
                child: Column(
                  children: [
                    ProfileHeader(user),
                    SizedBox(height: 8),
                    SmallProgressViewPage(user.progressMonitors),
                    SizedBox(height: 8),
                    Divider(height: 0),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16.0, top: 6.0),
                    child: Text(
                      'Achievements and Goals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AchievementPage(),
                ],
              ),
              GoalPage(),
              SizedBox(height: 10.0),
              Divider(),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Progresstracker',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (false)
                ProgressChart(
                  chartData: FredericChartData(
                      'ATo1D6xT5G5oi9W6s1q9', FredericGoalType.Weight),
                ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
