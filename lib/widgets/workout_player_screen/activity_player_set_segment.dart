import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'activity_player_view.dart';

class ActivityPlayerSetSegment extends StatelessWidget {
  const ActivityPlayerSetSegment(this.activity,
      {required this.controller, Key? key})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<BooleanChangeNotifier>(builder: (context, finished, child) {
      return BlocBuilder<FredericSetManager, FredericSetListData>(
          buildWhen: (current, next) =>
              next.changedActivities.contains(activity.activity.activityID),
          builder: (context, setListData) {
            double itemExtent = 60;

            var todaysSets =
                setListData[activity.activity.activityID].getTodaysSets();

            int numberOfSetsTODO = activity.sets;
            int numberOfSetsDone = todaysSets.length;
            int numberOfSetsTODOToDisplay = numberOfSetsTODO - numberOfSetsDone;
            if (numberOfSetsTODOToDisplay < 0) numberOfSetsTODOToDisplay = 0;
            int numberOfSetsTotal =
                numberOfSetsDone + numberOfSetsTODOToDisplay;

            int indexCurrentSet = numberOfSetsDone;
            bool everythingComplete = numberOfSetsDone >= numberOfSetsTODO;

            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              jumpTo(indexCurrentSet * itemExtent);
              finished.value = everythingComplete;
            });

            //int currentFirstItem = widget.controller.offset ~/ itemExtent;
            //print(currentFirstItem);

            return LayoutBuilder(builder: (context, constraints) {
              double availableHeight = constraints.maxHeight;
              int itemCount = availableHeight ~/ itemExtent;
              double listHeight = itemCount * itemExtent;
              return Column(
                children: [
                  Container(
                    height: listHeight,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy.abs() >= 1) {
                          if (details.delta.dy < 0) {
                            jumpTo(controller.offset + itemExtent);
                          } else {
                            jumpTo(controller.offset - itemExtent);
                          }
                        }
                      },
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                          return true;
                        },
                        child: ListView.builder(
                          //key: UniqueKey(),
                          //key: ValueKey<int>(numberOfSetsTotal),
                          controller: controller,
                          prototypeItem: _SetCard(),
                          itemCount: numberOfSetsTotal + 1,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index >= numberOfSetsTotal) {
                              return _SetCard(
                                finished: everythingComplete,
                                disabled: !everythingComplete,
                                last: true,
                              );
                            } else if (index > indexCurrentSet) {
                              // sets still todo:
                              return _SetCard(
                                reps: activity.reps,
                                disabled: true,
                              );
                            } else if (index == indexCurrentSet) {
                              // current set:
                              return _SetCard(
                                reps: activity.reps,
                              );
                            } else {
                              // sets already done:
                              int reps = activity.reps;
                              if (index < todaysSets.length)
                                reps = todaysSets[index].reps;
                              return _SetCard(
                                reps: reps,
                                finished: true,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              );
            });
          });
    });
  }

  void jumpTo(double offset) {
    if (controller.hasClients)
      controller.animateTo(offset,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}

class _SetCard extends StatelessWidget {
  const _SetCard(
      {this.finished = false,
      this.disabled = false,
      this.last = false,
      this.reps = 10,
      this.weight = 50,
      Key? key})
      : super(key: key);

  final bool finished;
  final bool disabled;
  final bool last;
  final int reps;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
                        color: disabled
                            ? theme.disabledGreyColor.withAlpha(50)
                            : finished
                                ? theme.positiveColorLight
                                : theme.mainColorLight,
                      ),
                      child: Icon(
                        ExtraIcons.statistics,
                        color: disabled
                            ? theme.greyTextColor
                            : finished
                                ? theme.positiveColor
                                : theme.mainColorInText,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 16),
                    if (last)
                      Text('You completed this exercise today!',
                          style: TextStyle(
                              color: theme.textColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                    if (!last)
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                    if (!last) Icon(Icons.check_box_outlined)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class _ListIcon extends StatelessWidget {
  _ListIcon({this.finished = false, this.disabled = false});
  final bool finished;
  final bool disabled;

  Widget circle(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }

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
            children: disabled
                ? [
                    circle(disabledColor, 7),
                    circle(disabledColor.withOpacity(0.1), 14)
                  ]
                : finished
                    ? [
                        circle(finishedColor, 6),
                        circle(finishedColor.withOpacity(0.1), 14)
                      ]
                    : [
                        circle(activeColor, 6),
                        circle(activeColor.withOpacity(0.1), 14)
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
                      colors: disabled
                          ? [disabledColor, disabledColor.withAlpha(0)]
                          : finished
                              ? [finishedColor, finishedColor.withAlpha(0)]
                              : [activeColor, activeColor.withAlpha(0)]),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
            ),
          ),
        ],
      ),
    );
  }
}
