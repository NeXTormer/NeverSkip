import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/activity_screen/activity_card.dart';
import 'package:frederic/widgets/activity_screen/appbar/activity_flexiable_appbar.dart';

class ActivityScreen extends StatefulWidget {
  static var routeName = 'activity-list';

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  StreamController<List<FredericActivity>> activityStreamController;

  @override
  Widget build(BuildContext context) {
    activityStreamController = FredericBackend.getAllActivitiesStream();
    Stream<List<FredericActivity>> stream = activityStreamController.stream;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            title: Container(
              child: Row(
                children: [
                  Icon(Icons.filter_alt),
                  SizedBox(width: 4),
                  Text(
                    'Activites',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: ActivityFlexibleAppbar(),
            ),
          ),
          StreamBuilder<List<FredericActivity>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ActivityCard(snapshot.data[index % 3]),
                      childCount: snapshot.data.length * 3,
                    ),
                  );
                }
                return SliverToBoxAdapter(child: Container());
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    activityStreamController.close();

    super.dispose();
  }
}
