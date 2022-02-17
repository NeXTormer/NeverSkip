import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/widgets/charts/training_volume_week_chart_page.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class TrainingVolumeChartSegment extends StatefulWidget {
  @override
  State<TrainingVolumeChartSegment> createState() =>
      _TrainingVolumeChartSegmentState();
}

class _TrainingVolumeChartSegmentState
    extends State<TrainingVolumeChartSegment> {
  PageController pageController = PageController();
  String subtitle = '';

  @override
  void initState() {
    super.initState();
    pageController.addListener(handlePageChange);
    subtitle = tr('home.chart.0week');
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 22, bottom: 8),
          child: FredericHeading(
            tr('home.chart.title_training_volume_week'),
            subHeading: subtitle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: BlocBuilder<FredericSetManager, FredericSetListData>(
              builder: (context, setListData) {
            List<int> volume = setListData.weeklyTrainingVolume;

            return FredericCard(
                height: 216,
                padding: EdgeInsets.all(16),
                child: PageView(
                  reverse: true,
                  controller: pageController,
                  children: [
                    TrainingVolumeWeekChartPage(volume.sublist(21, 28)),
                    TrainingVolumeWeekChartPage(volume.sublist(14, 21)),
                    TrainingVolumeWeekChartPage(volume.sublist(7, 14)),
                    TrainingVolumeWeekChartPage(volume.sublist(0, 7)),
                  ],
                ));
          }),
        )
      ],
    ));
  }

  ///TODO: This gets called wayyy to often, make more efficient
  void handlePageChange() {
    setState(() {
      switch (pageController.page?.round() ?? 0) {
        case 0:
          subtitle = tr('home.chart.0week');
          break;
        case 1:
          subtitle = tr('home.chart.1week');
          break;
        case 2:
          subtitle = tr('home.chart.2week');
          break;
        case 3:
          subtitle = tr('home.chart.3week');
          break;
        default:
          subtitle = tr('home.chart.0week');
      }
    });
  }

  @override
  void dispose() {
    pageController.removeListener(handlePageChange);
    super.dispose();
  }
}
