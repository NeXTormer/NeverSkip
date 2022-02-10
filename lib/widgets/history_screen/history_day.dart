import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/history_screen/history_activity_card.dart';
import 'package:frederic/widgets/history_screen/history_date_card.dart';

class HistoryDay extends StatelessWidget {
  const HistoryDay({required this.day, Key? key}) : super(key: key);

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final backend = FredericBackend.instance;
    final sets = backend.setManager.state.getSetHistoryByDay(day);
    if (sets.isEmpty) return Container();
    return Container(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Column(
          children: [
            HistoryDateCard(day),
            const SizedBox(height: 8),
            for (final x in sets.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: HistoryActivityCard(
                    activity: backend.activityManager[x.key] ??
                        FredericActivity.noSuchActivity(x.key),
                    sets: x.value),
              )
          ],
        ));
  }
}
