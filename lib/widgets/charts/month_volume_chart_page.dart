import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 24),
              buildDayText(tr('dates.short.monday')),
              buildDayText(tr('dates.short.tuesday')),
              buildDayText(tr('dates.short.wednesday')),
              buildDayText(tr('dates.short.thursday')),
              buildDayText(tr('dates.short.friday')),
              buildDayText(tr('dates.short.saturday')),
              buildDayText(tr('dates.short.sunday'))
            ],
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
        VolumeSliderMonth(DateTime(2022, 01)),
        VolumeSliderMonth(DateTime(2022, 02)),
        VolumeSliderMonth(DateTime(2022, 03)),
        VolumeSliderMonth(DateTime(2022, 04)),
        VolumeSliderMonth(DateTime(2022, 05)),
        VolumeSliderMonth(DateTime(2022, 06)),
        VolumeSliderMonth(DateTime(2022, 01)),
        VolumeSliderMonth(DateTime(2022, 02)),
        VolumeSliderMonth(DateTime(2022, 03)),
        VolumeSliderMonth(DateTime(2022, 04)),
        VolumeSliderMonth(DateTime(2022, 05)),
        VolumeSliderMonth(DateTime(2022, 06)),
      ],
    );
  }
}

class VolumeSliderMonth extends StatelessWidget {
  const VolumeSliderMonth(this.month, {Key? key}) : super(key: key);
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('MMMM', context.locale.toString());

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(format.format(month),
                style: TextStyle(
                    color: theme.greyTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13)),
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
