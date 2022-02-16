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

  final double chest;
  final double abs;
  final double legs;
  final double arms;
  final double back;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: PieChart(PieChartData(
          sectionsSpace: 4,
          pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {}),
          sections: getExampleData(),
          centerSpaceRadius: double.infinity,
          centerSpaceColor: theme.backgroundColor)),
    );
  }

  List<PieChartSectionData> getExampleData() {
    return [
      PieChartSectionData(
          value: legs,
          color: Color.alphaBlend(theme.mainColor, theme.accentColor),
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fleg.png?alt=media&token=611cf8b1-5494-4e60-a260-7b5a9c810dbc',
          )),
      PieChartSectionData(
          value: abs,
          color: theme.accentColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fabs.png?alt=media&token=00fc6429-17d8-4917-9a8c-27f912f10c87',
          )),
      PieChartSectionData(
          value: chest,
          color: theme.mainColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fbody.png?alt=media&token=a9b25f01-28e5-4c0c-8586-61d21a8a22bf',
          )),
      PieChartSectionData(
          value: arms,
          color: theme.accentColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fbodybuilding.png?alt=media&token=ae9756a1-3fef-43b2-a036-36370dc33c7c',
          )),
      PieChartSectionData(
          value: back,
          color: theme.mainColor,
          showTitle: false,
          badgePositionPercentageOffset: 1,
          badgeWidget: RoundPictureIcon(
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fback.png?alt=media&token=90b80f9e-5ed1-4def-9674-02a4c7a67900',
          ))
    ];
  }
}