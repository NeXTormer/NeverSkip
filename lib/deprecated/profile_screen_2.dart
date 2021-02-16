import 'package:flutter/material.dart';
import 'package:frederic/screens/add_graph_screen.dart';
import 'package:frederic/widgets/profile_screen/goal/edit_goal_slidesheet.dart';

enum AddOptions {
  Goal,
  Graph,
}

class ProfileScreen2 extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreen2State createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
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
            'Sascha Huber',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            'Hier ein Platzhalter Text, damit es gut aussieht',
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )
        ],
      ),
    );
  }

  /// Outsources the Stats-Text section
  ///
  /// Currently builds [subText] above [boldText] in a Column
  Widget buildStatisticText(
      BuildContext context, String boldText, String subText) {
    return Container(
      child: Column(
        children: [
          Text(
            subText,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            boldText,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  /// On pressed show ModalBottomSheet
  ///
  /// The bottom sheet contains the [EditSlideSheet] Widget
  /// so the user can interact with the goal.
  void _onButtonPressed(String id) {
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
              child: EditGoalSlidesheet(id),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('Sascha Huber'),
          leading: Icon(Icons.person),
          actions: [
            PopupMenuButton(
              onSelected: (addOption) {
                /// Either show the [EditSlideSheet] bottom sheet or the [AddGraphScreen] to add a progress tracker
                if (addOption == AddOptions.Goal) {
                  _onButtonPressed(null);
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
              Row(
                children: [
                  //ProfileAvatar(),
                  buildProfileText(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildStatisticText(context, 'Push Ups', '40'),
                  buildStatisticText(context, 'Pull Ups', '10'),
                  buildStatisticText(context, 'Dips', '20'),
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16.0, top: 6.0),
                    child: Text(
                      'Achivements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //AchievementPage(),
                ],
              ),
              //GoalPage(_onButtonPressed),
              SizedBox(height: 10.0),
              Divider(),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Progress - Tracker',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              //ProgressPage(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavDesign(0),
    );
  }
}
