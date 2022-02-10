import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/history_screen/history_day.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  FredericSetManager? setManager;

  @override
  void initState() {
    setManager = FredericBackend.instance.setManager;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return FredericScaffold(
        body: CustomScrollView(
      slivers: [
        FredericSliverAppBar(
          title: 'Exercise History',
          icon: Icon(
            ExtraIcons.statistics,
            color: theme.textColorColorfulBackground,
          ),
          subtitle: 'Your past sets',
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 8),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return HistoryDay(
              day: today.subtract(Duration(days: index)),
            );
          }, childCount: 100)),
        ),
      ],
    ));
  }
}
