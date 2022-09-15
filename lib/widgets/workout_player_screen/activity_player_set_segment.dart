import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/widgets/standard_elements/shadow_list_view.dart';
import 'package:frederic/widgets/workout_player_screen/activity_player_view.dart';
import 'package:frederic/widgets/workout_player_screen/short_set_card.dart';
import 'package:provider/provider.dart';

class ActivityPlayerSetSegment extends StatelessWidget {
  const ActivityPlayerSetSegment(this.activity,
      {required this.controller, Key? key})
      : super(key: key);

  final FredericWorkoutActivity activity;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericSetManager, FredericSetListData>(
        buildWhen: (current, next) =>
            next.changedActivities.contains(activity.activity.id),
        builder: (context, setListData) {
          double itemExtent = 60;

          var todaysSets = setListData[activity.activity.id].getTodaysSets();

          int numberOfSetsTODO = activity.sets;
          int numberOfSetsDone = todaysSets.length;
          int numberOfSetsTODOToDisplay = numberOfSetsTODO - numberOfSetsDone;
          if (numberOfSetsTODOToDisplay < 0) numberOfSetsTODOToDisplay = 0;
          int numberOfSetsTotal = numberOfSetsDone + numberOfSetsTODOToDisplay;

          int indexCurrentSet = numberOfSetsDone;
          bool everythingComplete = numberOfSetsDone >= numberOfSetsTODO;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controller.jumpTo(0);
            jumpTo(indexCurrentSet * itemExtent);
          });
          Future(() {
            Provider.of<BooleanChangeNotifier>(context, listen: false).value =
                everythingComplete;
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
                        overscroll.disallowIndicator();
                        return true;
                      },
                      child: ShadowListView(
                        blurPadding: const EdgeInsets.only(left: 24),
                        controller: controller,
                        shadowWidth: 12,
                        prototypeItem: ShortSetCard(),
                        itemCount: numberOfSetsTotal + 1,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index >= numberOfSetsTotal) {
                            return ShortSetCard(
                              finished: everythingComplete,
                              disabled: !everythingComplete,
                              last: true,
                            );
                          } else if (index > indexCurrentSet) {
                            // sets still to do:
                            return ShortSetCard(
                              reps: activity.reps,
                              disabled: true,
                            );
                          } else if (index == indexCurrentSet) {
                            // current set:
                            return ShortSetCard(
                              reps: activity.reps,
                            );
                          } else {
                            // sets already done:
                            int reps = activity.reps;
                            if (index < todaysSets.length)
                              reps = todaysSets[index].reps;
                            return ShortSetCard(
                              reps: reps,
                              finished: true,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                //Expanded(child: Container()),
              ],
            );
          });
        });
  }

  void jumpTo(double offset) {
    controller.animateTo(offset,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
