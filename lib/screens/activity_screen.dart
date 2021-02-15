import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/activity_screen/activity_card.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_controller.dart';
import 'package:frederic/widgets/activity_screen/appbar/activity_flexiable_appbar.dart';
import 'package:provider/provider.dart';

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
      body: ChangeNotifierProvider<ActivityFilterController>(
        create: (context) => ActivityFilterController(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              title: Container(
                child: Row(
                  children: [
                    Icon(Icons.filter_alt),
                    SizedBox(width: 8),
                    Text(
                      'Exercises',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Consumer<ActivityFilterController>(
                  builder: (context, filter, child) {
                    return ActivityFlexibleAppbar(filterController: filter);
                  },
                ),
              ),
            ),
            StreamBuilder<List<FredericActivity>>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Consumer<ActivityFilterController>(
                      builder: (context, filter, child) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (snapshot.data[index]
                                .matchFilterController(filter)) {
                              return ActivityCard(snapshot.data[index]);
                            }
                            return Container();
                          },
                          childCount: snapshot.data.length,
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(child: Container());
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavDesign(3),
    );
  }

  @override
  void dispose() {
    //activityStreamController.close(); //TODO: Causes issues with hotreload but
    //                                  //TODO: should normally be enabled

    super.dispose();
  }
}
