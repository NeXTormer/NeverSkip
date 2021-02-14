import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_chart_data.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/screens/add_graph_screen.dart';
import 'package:frederic/widgets/profile_screen/achievement_page.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_page.dart';
import 'package:frederic/widgets/profile_screen/profile_avatar.dart';
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

  /// Outsource the Profile-Text section
  ///
  /// Currently build a static [profile name] and [subtext].
  Widget buildProfileText() {
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            user.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )
        ],
      ),
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
              child: Text(id),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    user = FredericBackend.of(context).currentUser;

    return StreamBuilder<FredericUser>(
      stream: FredericBackend.of(context).currentUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  title: Text(user.name),
                  leading: InkWell(
                      child: Icon(Icons.person),
                      onTap: () => FirebaseAuth.instance.signOut()),
                  actions: [
                    PopupMenuButton(
                      onSelected: (addOption) {
                        // Either show the [EditSlideSheet] bottom sheet or the [AddGraphScreen] to add a progress tracker
                        if (addOption == AddOptions.Goal) {
                          _handleButtonPress(null);
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
                            Row(
                              children: [
                                ProfileAvatar(imageUrl: user.image),
                                Expanded(child: buildProfileText()),
                                SizedBox(width: 16)
                              ],
                            ),
                            SmallProgressViewPage(),
                            SizedBox(height: 12),
                            Divider(
                              height: 0,
                            ),
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
                      GoalPage(_handleButtonPress),
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
}
