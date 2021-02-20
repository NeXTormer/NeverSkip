import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity_consumer.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';
import 'package:frederic/widgets/activity_screen/activity_card.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_controller.dart';
import 'package:frederic/widgets/activity_screen/appbar/activity_flexible_appbar.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen(
      {this.isSelector = false,
      this.onAddActivity,
      this.itemsDismissable = false,
      this.onItemDismissed});

  static var routeName = 'activity-list';

  final bool isSelector;
  final Function(FredericActivity) onAddActivity;
  final bool itemsDismissable;
  final Function(FredericActivity) onItemDismissed;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  StreamController<List<FredericActivity>> activityStreamController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityFilterController>(
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
          FredericActivityBuilder(
            builder: (context, list) {
              return Consumer<ActivityFilterController>(
                builder: (context, filter, child) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      FredericActivity a = list[index];
                      if (a.matchFilterController(filter)) {
                        return ActivityCard(
                          a,
                          selectable: widget.isSelector,
                          onAddActivity: widget.onAddActivity,
                          dismissible: widget.itemsDismissable,
                          onDismiss: widget.onItemDismissed,
                        );
                      }
                      return Container();
                    },
                    childCount: list.length,
                  ),
                ),
              );
            },
          ),
          if (false)
            Consumer<FredericActivityManager>(
                builder: (context, activityManager, child) {
              return Consumer<ActivityFilterController>(
                builder: (context, filter, child) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      FredericActivity a =
                          activityManager.activities.elementAt(index);
                      if (a.matchFilterController(filter)) {
                        return ActivityCard(
                          a,
                          selectable: widget.isSelector,
                          onAddActivity: widget.onAddActivity,
                          dismissible: widget.itemsDismissable,
                          onDismiss: widget.onItemDismissed,
                        );
                      }
                      return Container();
                    },
                    childCount: activityManager.activities.length,
                  ),
                ),
              );
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
