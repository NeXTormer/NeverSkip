import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_user_builder.dart';
import 'package:frederic/widgets/profile_screen/achievement_page.dart';
import 'package:frederic/widgets/profile_screen/goal/finish_goal_view.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_page.dart';
import 'package:frederic/widgets/profile_screen/profile_header.dart';
import 'package:frederic/widgets/profile_screen/small_progress_view_page.dart';
import 'package:frederic/widgets/progress_chart/progress_chart.dart';

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
              child: Column(children: [
                Container(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Center(
                          child: Column(
                    children: [
                      SizedBox(height: 12),
                      Text('Coming soon...',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[500])),
                      SizedBox(
                        height: 6,
                      ),
                      Text('We are working hard to implement this feature',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500])),
                      SizedBox(height: 2)
                    ],
                  ))),
                ),
                if (false)
                  ProgressChart(
                    chartData: FredericChartData(
                        'ATo1D6xT5G5oi9W6s1q9', FredericGoalType.Weight),
                  ),
                SizedBox(height: 50),
              ]),
            ));
  }

  /// On pressed show ModalBottomSheet
  ///
  /// The bottom sheet contains the [EditSlideSheet] Widget
  /// so the user can interact with the goal.
  void _addGoalPopUp(String id) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 10,
        backgroundColor: Colors.transparent,
        child: FinishGoalView(null, Mode.EDIT),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
