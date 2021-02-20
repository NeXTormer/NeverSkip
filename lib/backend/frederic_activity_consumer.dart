import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';

class FredericActivityBuilder extends StatefulWidget {
  FredericActivityBuilder({Key key, this.builder, this.activityID})
      : super(key: key);

  final String activityID;
  final Widget Function(BuildContext, List<FredericActivity>) builder;

  @override
  _FredericActivityBuilderState createState() =>
      _FredericActivityBuilderState();
}

class _FredericActivityBuilderState extends State<FredericActivityBuilder> {
  List<FredericActivity> _activityList;

  @override
  void initState() {
    FredericActivityManager.instance().addListener(updateData);
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _activityList);
  }

  void updateData() {
    setState(() {
      if (widget.activityID == null) {
        _activityList = FredericActivityManager.instance().activities.toList();
      } else {
        _activityList = List<FredericActivity>(1);
        _activityList
            .add(FredericActivityManager.instance()[widget.activityID]);
      }
    });
  }
}
