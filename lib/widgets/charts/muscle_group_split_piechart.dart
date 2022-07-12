import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/round_picture_icon.dart';

class MuscleGroupSplitPiechart extends StatelessWidget {
  const MuscleGroupSplitPiechart(
      {this.chest = 0,
      this.abs = 0,
      this.legs = 0,
      this.arms = 0,
      this.back = 0,
      Key? key})
      : super(key: key);

  final int chest;
  final int abs;
  final int legs;
  final int arms;
  final int back;

  @override
  Widget build(BuildContext context) {
    if (chest + abs + legs + arms + back == 0) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Text(
          'No data in the last 28 days. Add your progress to an exercise to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.greyTextColor),
        )),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: PieChart(PieChartData(
          sectionsSpace: 4,
          sections: getExampleData(),
          centerSpaceRadius: double.infinity,
          centerSpaceColor: theme.backgroundColor)),
    );
  }

  List<PieChartSectionData> getExampleData() {
    return [
      PieChartSectionData(
          value: legs.toDouble(),
          color: Color.alphaBlend(theme.mainColor, theme.accentColor),
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fleg.png?alt=media&token=611cf8b1-5494-4e60-a260-7b5a9c810dbc',
          )),
      PieChartSectionData(
          value: abs.toDouble(),
          color: theme.accentColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fabs.png?alt=media&token=00fc6429-17d8-4917-9a8c-27f912f10c87',
          )),
      PieChartSectionData(
          value: chest.toDouble(),
          color: theme.mainColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fbody.png?alt=media&token=a9b25f01-28e5-4c0c-8586-61d21a8a22bf',
          )),
      PieChartSectionData(
          value: arms.toDouble(),
          color: theme.accentColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fbodybuilding.png?alt=media&token=ae9756a1-3fef-43b2-a036-36370dc33c7c',
          )),
      PieChartSectionData(
          value: back.toDouble(),
          color: theme.mainColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fback.png?alt=media&token=90b80f9e-5ed1-4def-9674-02a4c7a67900',
          ))
    ];
  }
}
