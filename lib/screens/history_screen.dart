import 'package:flutter/material.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/history_screen/history_date_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
        body: CustomScrollView(
      slivers: [
        FredericSliverAppBar(
          title: 'Exercise History',
          icon: Icon(ExtraIcons.statistics),
          subtitle: 'Your past sets',
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: HistoryDateCard(DateTime.now()),
        ))
      ],
    ));
  }
}
