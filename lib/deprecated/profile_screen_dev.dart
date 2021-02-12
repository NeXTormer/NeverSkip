import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/profile_header.dart';
import 'package:frederic/widgets/profile_screen/graph/progress_page.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  Widget buildProfileText(
      BuildContext context, String mainText, String subText, var marginLeft) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft, top: 0.0),
      child: ListTile(
        title: Text(
          mainText,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(subText),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(FredericBackend.of(context).currentUser.name),
          leading: Icon(Icons.person),
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: () {}),
            IconButton(icon: Icon(Icons.list), onPressed: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            buildProfileText(context, 'Sascha Huberdd',
                'Weijdnksdjnsdfkdjfnksnfdkfsdkfnsdfnkjnsdkfnsß net', 130.0),
            SizedBox(height: 16.0),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 6.0),
                  child: Text(
                    'Achivements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      6,
                      (_) {
                        // return CircleItem('');
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            //GoalPage(),
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
            //CardProgressTracker(),
            ProgressPage(),
            SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        color: Colors.black45,
        backgroundColor: Colors.white,
        activeColor: Colors.red,
        height: 50.0,
        items: [
          TabItem(icon: Icons.person),
          TabItem(icon: Icons.access_alarm),
          TabItem(icon: Icons.accessibility),
          TabItem(icon: Icons.list),
        ],
      ),
    );
  }
}
