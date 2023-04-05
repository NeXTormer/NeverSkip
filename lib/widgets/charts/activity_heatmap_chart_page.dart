import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/shadow_custom_scroll_view.dart';

class ActivityHeatmapChartPage extends StatelessWidget {
  const ActivityHeatmapChartPage({required this.setListData, Key? key})
      : super(key: key);

  final FredericSetListData setListData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Expanded(child: VolumeSliderView(setListData: setListData))
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
  const VolumeSliderView({required this.setListData, Key? key})
      : super(key: key);

  final FredericSetListData setListData;

  @override
  Widget build(BuildContext context) {
    final profiler = FredericProfiler.track('YearChart Calculate Year');
    List<DateTime> months = <DateTime>[];
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    months.add(today);

    int year = today.year;
    int month = today.month;
    for (int i = 0; i < 5; i++) {
      var current = DateTime(year, month, 1);
      do {
        current = current.subtract(const Duration(days: 1));
      } while (current.weekday != 7);
      months.add(current);

      month--;
      if (month < 1) {
        month = 12;
        year--;
      }
    }

    profiler.stop();

    return ShadowCustomScrollView(
      scrollDirection: Axis.horizontal,
      blurPadding: const EdgeInsets.only(top: 0),
      reverse: true,
      slivers: [
        for (final month in months)
          VolumeSliderMonth(
            startingDay: month,
            setListData: setListData,
            tinted: month.month % 2 == 1,
          ),
      ],
    );
  }
}

class VolumeSliderMonth extends StatelessWidget {
  const VolumeSliderMonth(
      {required this.startingDay,
      required this.setListData,
      this.tinted = false,
      Key? key})
      : super(key: key);

  final DateTime startingDay;
  final FredericSetListData setListData;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final profiler = FredericProfiler.track('YearChart Calculate Month');
    final DateFormat format = DateFormat('MMMM', context.locale.toString());
    List<DateTime?> dates = <DateTime?>[];

    for (int i = 0; i < (7 - startingDay.weekday); i++) dates.add(null);

    int i = 0;
    while (true) {
      DateTime current = startingDay.subtract(Duration(days: i));
      if (current.month != startingDay.month) {
        if (current.weekday == 1) {
          dates.add(DateTime(current.year, current.month, current.day));
          break;
        }
      }
      dates.add(DateTime(current.year, current.month, current.day));

      if (current.month == startingDay.month &&
          current.day == 1 &&
          current.weekday == 1) {
        break;
      }

      i++;
    }

    dates = dates.reversed.toList();
    profiler.stop();
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(format.format(startingDay),
                style: TextStyle(
                    color: theme.greyTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13)),
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
                    for (int i = 0; i < dates.length; i++)
                      _DayCard(dates[i]?.day.toString(),
                          volume: dates[i] == null
                              ? 0
                              : setListData.volume[dates[i]]?.volume ?? 0.88,
                          size: size,
                          tinted: tinted
                              ? (dates[i]?.month == startingDay.month &&
                                  (dates[i]?.day ?? 0) <= i + 1)
                              : (dates[i]?.day ?? 0) >=
                                  i + 2 /* idk why i+2 works but it does*/),
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
  const _DayCard(this.day,
      {required this.volume, this.size = 22, this.tinted = false, Key? key})
      : super(key: key);
  final String? day;
  final double size;
  final double volume;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    if (day == null) return SizedBox(height: size, width: size);
    double opacity = volume / 4000.0;
    if (opacity > 1) opacity = 1;

    Color tintedColor = Colors.grey.withAlpha(55);
    return FredericCard(
      height: size,
      borderWidth: 0.6,
      color: tinted && volume < 1
          ? tintedColor
          : theme.accentColor.withOpacity(opacity),
      borderRadius: 6,
      width: size,
      child: Center(
        child: Text(
          day!,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: (opacity > 0.7
                  ? theme.textColorColorfulBackground
                  : theme.textColor)),
        ),
      ),
    );
  }
}
