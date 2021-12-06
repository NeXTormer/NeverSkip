import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';

import '../../main.dart';

class ActivityPlayerSetSegment extends StatefulWidget {
  const ActivityPlayerSetSegment(this.activity,
      {required this.setListData, Key? key})
      : super(key: key);

  final FredericSetListData setListData;
  final FredericWorkoutActivity activity;

  @override
  State<ActivityPlayerSetSegment> createState() =>
      _ActivityPlayerSetSegmentState();
}

class _ActivityPlayerSetSegmentState extends State<ActivityPlayerSetSegment> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double itemExtent = 60;
      double availableHeight = constraints.maxHeight;
      int itemCount = availableHeight ~/ itemExtent;
      double listHeight = itemCount * itemExtent;
      return Column(
        children: [
          Container(
            height: listHeight,
            child: ListView.builder(
              controller: controller,
              prototypeItem: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SetCard(),
              ),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SetCard(reps: index),
                );
              },
              itemCount: 10,
              scrollDirection: Axis.vertical,
            ),
          ),
          Expanded(child: Container()),
        ],
      );
    });
  }
}

class _SetCard extends StatelessWidget {
  const _SetCard(
      {this.finished = false,
      this.disabled = false,
      this.reps = 10,
      this.weight = 50,
      Key? key})
      : super(key: key);

  final bool finished;
  final bool disabled;
  final int reps;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 28),
        Container(
          height: 46,
          child: _ListIcon(disabled: disabled, finished: finished),
        ),
        SizedBox(width: 6),
        Expanded(
          child: FredericCard(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: theme.mainColorLight),
                    child: Icon(
                      ExtraIcons.statistics,
                      color: theme.mainColorInText,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      '$reps',
                      style: TextStyle(
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: 14),
                    ),
                    SizedBox(width: 3),
                    Text('reps',
                        style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: 12)),
                    SizedBox(width: 10),
                    FredericVerticalDivider(length: 16),
                    SizedBox(width: 10),
                    Text(
                      '$weight',
                      style: TextStyle(
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: 14),
                    ),
                    SizedBox(width: 3),
                    Text('kg',
                        style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: 12)),
                  ]),
                  Expanded(child: Container()),
                  Icon(Icons.check_box_outlined)
                ],
              )),
        ),
      ],
    );
  }
}

class _ListIcon extends StatelessWidget {
  _ListIcon({this.finished = false, this.disabled = false});
  final bool finished;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    Color activeColor = theme.mainColorInText;
    Color disabledColor = theme.disabledGreyColor;
    Color finishedColor = theme.positiveColor;
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: !disabled
                ? [
                    circle(activeColor, 6),
                    circle(activeColor.withOpacity(0.1), 14)
                  ]
                : finished
                    ? [
                        circle(finishedColor, 6),
                        circle(finishedColor.withOpacity(0.1), 14)
                      ]
                    : [
                        circle(disabledColor, 12),
                        circle(Colors.white, 4),
                        circle(Colors.transparent, 14)
                      ],
          ),
          SizedBox(height: 4),
          Expanded(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: !disabled
                          ? [activeColor, activeColor.withAlpha(0)]
                          : [disabledColor, disabledColor.withAlpha(0)]),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
            ),
          ),
        ],
      ),
    );
  }

  Widget circle(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }
}
