import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class MonthVolumeChartPage extends StatelessWidget {
  const MonthVolumeChartPage({required this.setListData, Key? key})
      : super(key: key);

  final FredericSetListData setListData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildDayText(tr('dates.short.monday')),
                buildDayText(tr('dates.short.tuesday')),
                buildDayText(tr('dates.short.wednesday')),
                buildDayText(tr('dates.short.thursday')),
                buildDayText(tr('dates.short.friday')),
                buildDayText(tr('dates.short.saturday')),
                buildDayText(tr('dates.short.sunday')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: VolumeSliderView())
        ],
      ),
    );
  }

  Widget buildDayText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: theme.greyTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 13),
    );
  }
}

class VolumeSliderView extends StatelessWidget {
  const VolumeSliderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      reverse: true,
      slivers: [
        VolumeSliderMonth(
          month: DateTime(2022, 02),
          startingDay: DateTime(2022, 02, 23),
        ),
        VolumeSliderMonth(
          month: DateTime(2022, 01),
          startingDay: DateTime(2022, 01, 30),
        ),
        VolumeSliderMonth(
          month: DateTime(2021, 12),
          startingDay: DateTime(2021, 12, 26),
        ),
        VolumeSliderMonth(
          month: DateTime(2021, 11),
          startingDay: DateTime(2021, 11, 28),
        ),
        //VolumeSliderMonth(DateTime(2022, 02)),
      ],
    );
  }
}

class VolumeSliderMonth extends StatelessWidget {
  const VolumeSliderMonth(
      {required this.month, required this.startingDay, Key? key})
      : super(key: key);
  final DateTime month;
  final DateTime startingDay;

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('MMMM', context.locale.toString());
    print("REBUILD MONTH");
    List<DateTime?> dates = <DateTime?>[];

    for (int i = 0; i < (7 - startingDay.weekday); i++) dates.add(null);

    int i = 0;
    while (true) {
      DateTime current = startingDay.subtract(Duration(days: i));
      if (current.month != month.month) {
        if (current.weekday == 1) {
          dates.add(current);
          break;
        }
      }
      dates.add(current);

      i++;
    }

    dates = dates.reversed.toList();

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(format.format(month),
                style: TextStyle(
                    color: theme.greyTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13)),
            //if (false)
            SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final maxHeight = constraints.maxHeight;
                final spacing = 2.0;
                final freeSpace = maxHeight - (spacing * 6);
                final size = freeSpace / 7;

                return Wrap(
                  direction: Axis.vertical,
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final day in dates)
                      _DayCard(
                        day?.day.toString(),
                        size: size,
                      ),
                  ],
                );
              }),
            )
          ],
        ),
      ),
    ));
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard(this.day, {this.size = 22, Key? key}) : super(key: key);
  final String? day;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (day == null) return SizedBox(height: size, width: size);
    return FredericCard(
      height: size,
      color: theme.mainColorLight,
      borderRadius: 4,
      width: size,
      child: Center(
        child: Text(day!),
      ),
    );
  }
}
