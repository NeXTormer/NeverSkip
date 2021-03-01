import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_chart_data.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/screens/add_graph_screen.dart';
import 'package:frederic/widgets/profile_screen/achievement_page.dart';
import 'package:frederic/widgets/profile_screen/goal/add_goal_item.dart';
import 'package:frederic/widgets/profile_screen/goal/edit_goal_item.dart';
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
  FredericUser user;

  @override
  Widget build(BuildContext context) {
    user = FredericBackend.instance().currentUser;

    return StreamBuilder<FredericUser>(
      stream: FredericBackend.instance().currentUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: AppBar(
                  title: Text('Frederic'),
                  leading: InkWell(
                      child: Icon(Icons.person),
                      onTap: () => FirebaseAuth.instance.signOut()),
                  actions: [
                    PopupMenuButton(
                      onSelected: (addOption) {
                        // Either show the [EditSlideSheet] bottom sheet or the [AddGraphScreen] to add a progress tracker
                        if (addOption == AddOptions.Goal) {
                          //_handleButtonPress(null);
                          _addGoalPopUp(null);
                        } else {
                          Navigator.of(context)
                              .pushNamed(AddGraphScreen.routeName);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Add Goal'),
                          value: AddOptions.Goal,
                        ),
                        PopupMenuItem(
                          child: Text('Add Graph'),
                          value: AddOptions.Graph,
                        ),
                      ],
                      icon: Icon(Icons.add),
                    ),
                    IconButton(icon: Icon(Icons.list), onPressed: () {}),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        // contains profile header
                        color: Colors.white,
                        child: Column(
                          children: [
                            ProfileHeader(snapshot.data),
                            SizedBox(height: 8),
                            SmallProgressViewPage(
                                snapshot.data.progressMonitors),
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
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 6.0),
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
              ));
        } else {
          return Scaffold(
            body: Container(
                child: Center(
              child: Text('loading user data...'),
            )),
          );
        }
      },
    );
  }

  /// On pressed show ModalBottomSheet
  ///
  /// The bottom sheet contains the [EditSlideSheet] Widget
  /// so the user can interact with the goal.
  void _handleButtonPress(String id) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: EditGoalItem(null),
            ),
          ],
        );
      },
    );
  }

  void _addGoalPopUp(String id) {
    showDialog(context: context, builder: (context) => AddGoalItem());
  }
}
