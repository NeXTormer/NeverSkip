import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/activity_screen/activity_card.dart';

class ActivityPageView extends StatefulWidget {
  ActivityPageView(this.workout);

  final FredericWorkout workout;

  @override
  _ActivityPageViewState createState() => _ActivityPageViewState();
}

class _ActivityPageViewState extends State<ActivityPageView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ActivityPage extends StatelessWidget {
  _ActivityPage(this.activities);

  final List<FredericActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: activities
            .map((activity) => ActivityCard(
                  activity,
                  dismissable: true,
                  selectable: false,
                  onDismiss: handleDismissedActivity,
                ))
            .toList());
  }

  void handleDismissedActivity(FredericActivity activity) {
    print('dismissed ${activity.name}');
  }
}
