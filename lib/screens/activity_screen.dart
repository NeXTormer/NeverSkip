import 'package:flutter/material.dart';
import 'package:frederic/providers/activity.dart';
import 'package:frederic/widget/second_design/activity/activity_card.dart';
import 'package:frederic/widget/second_design/appbar/activity_flexiable_appbar.dart';
import 'package:frederic/widget/second_design/bottonNavBar/bottom_nav_design.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  static var routeName = 'activity-list';

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final List<ActivityItem> activities =
        Provider.of<Activity>(context, listen: false).independentActivities;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            title: Container(
              child: Row(
                children: [
                  Icon(Icons.filter_alt),
                  Text(
                    'Activites',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: ActivityFlexiableAppbar(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) => ActivityCard(activities[index], null, null),
              childCount: activities.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavDesign(3),
    );
  }
}
