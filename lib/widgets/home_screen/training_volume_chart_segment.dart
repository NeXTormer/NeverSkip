import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';

class TrainingVolumeChartSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 22, bottom: 8),
          child: FredericHeading(
            tr('home.training_volume_chart_title'),
            subHeading: tr('home.training_volume_chart_subtitle'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: BlocBuilder<FredericSetManager, FredericSetListData>(
              builder: (context, setListData) {
            List<int> volume = setListData.weeklyTrainingVolume;

            double highest = 0;
            double lowest = 0;
            for (int data in volume) {
              if (data > highest) highest = data.toDouble();
            }
            highest += (100 - (highest % 100));
            double midHigh = roundLegendText((highest / 3) * 2);
            double midLow = roundLegendText(highest / 3);

            return FredericCard(
              height: 216,
              padding: EdgeInsets.all(16),
              child: Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIndexText(highest),
                        buildIndexText(midHigh),
                        buildIndexText(midLow),
                        buildIndexText(lowest),
                      ],
                    ),
                  ),
                  ...buildAllWeekbars(volume, highest),
                ],
              )),
            );
          }),
        )
      ],
    ));
  }

  String getDay(int index) {
    switch (index) {
      case 0:
        return tr('dates.short.monday');
      case 1:
        return tr('dates.short.tuesday');
      case 2:
        return tr('dates.short.wednesday');
      case 3:
        return tr('dates.short.thursday');
      case 4:
        return tr('dates.short.friday');
      case 5:
        return tr('dates.short.saturday');
      case 6:
        return tr('dates.short.sunday');
      default:
        return tr('error');
    }
  }

  /// 'rounds' the provided double so that the last decimal place is always zero
  double roundLegendText(double raw) {
    num base = raw / 10;
    int exponent = (log(base) / ln10).floor();

    base = pow(10, exponent);

    return raw + (base - (raw % base));
  }

  Widget buildIndexText(double index) {
    return Text(
      '${index.truncate()}',
      style: TextStyle(
          color: theme.greyTextColor, fontSize: 11, letterSpacing: 0.3),
    );
  }

  List<Widget> buildAllWeekbars(List<int> volume, double highest) {
    List<Widget> list = <Widget>[];
    final now = DateTime.now();
    var weekday = now.weekday;
    weekday--;

    for (int i = 0; i < 7; i++) {
      weekday++;
      weekday %= 7;
      list.add(buildWeekBar(getDay(weekday), volume[i] / highest, i));
    }
    return list;
  }

  Widget buildWeekBar(String day, double value, int index) {
    return Expanded(
      child: Column(
        children: [
          ProgressBar(
            value,
            vertical: true,
            length: 160,
            thickness: 10,
            alternateColor: index % 2 == 1,
          ),
          SizedBox(height: 10),
          Text(
            day,
            style: TextStyle(
                color: theme.greyTextColor, fontSize: 10, letterSpacing: 0.4),
          )
        ],
      ),
    );
  }
}
