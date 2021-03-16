import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_chart_data.dart';
import 'package:frederic/backend/frederic_goal.dart';
import 'package:frederic/backend/frederic_user_builder.dart';
import 'package:frederic/screens/add_graph_screen.dart';
import 'package:frederic/screens/settings_screen.dart';
import 'package:frederic/widgets/profile_screen/achievement_page.dart';
import 'package:frederic/widgets/profile_screen/goal/finish_goal_view.dart';
import 'package:frederic/widgets/profile_screen/goal/goal_page.dart';
import 'package:frederic/widgets/profile_screen/profile_header.dart';
import 'package:frederic/widgets/profile_screen/small_progress_view_page.dart';
import 'package:frederic/widgets/progress_chart/progress_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frederic/widgets/user_feedback/user_feedback_toast.dart';

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
      builder: (context, user) => Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title: Text('Frederic'),
              leading: Icon(Icons.person),
              actions: [
                PopupMenuButton(
                  onSelected: (addOption) {
                    // Either show the [EditSlideSheet] bottom sheet or the [AddGraphScreen] to add a progress tracker
                    if (addOption == AddOptions.Goal) {
                      //_handleButtonPress(null);
                      _addGoalPopUp(null);
                    } else {
                      Navigator.of(context).pushNamed(AddGraphScreen.routeName);
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
                ),
                IconButton(
                  icon: Icon(Icons.settings_outlined),
                  onPressed: () {
                    //Navigator.of(context).pushNamed(SettingsScreen.routeName);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsScreen(user)));
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
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
            ),
          )),
    );
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
