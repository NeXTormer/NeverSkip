import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/util/event_bus/frederic_system_message.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/workout_player_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/activity_card.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/calendar_activity_card_content.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class CalendarDay extends StatelessWidget {
  CalendarDay(this.index, this.user, this.workoutListData, this.setListData) {
    currentDayIsToday = index == 0;
  }

  final FredericUser user;
  final FredericWorkoutListData workoutListData;
  final FredericSetListData? setListData;

  late final bool currentDayIsToday;

  final int index;

  @override
  Widget build(BuildContext context) {
    final profiler = FredericProfiler.track('build calendar day');
    DateTime day = DateTime.now().add(Duration(days: index));
    List<FredericWorkoutActivity> activitiesDueToday =
        <FredericWorkoutActivity>[];
    for (var activeWorkoutPair in user.activeWorkouts.entries) {
      if (workoutListData.workouts[activeWorkoutPair.key] != null) {
        activitiesDueToday.addAll(workoutListData
            .workouts[activeWorkoutPair.key]!.activities
            .getDay(day, activeWorkoutPair.value));
      }
    }
    bool dayFinished = true;
    List<bool> completedActivityToday = currentDayIsToday
        ? List.filled(activitiesDueToday.length, false)
        : <bool>[];
    if (currentDayIsToday) {
      if (setListData != null) {
        for (int i = 0; i < activitiesDueToday.length; i++) {
          FredericSetList setList =
              setListData![activitiesDueToday[i].activity.id];
          bool activityFinished = setList.wasActiveToday();
          completedActivityToday[i] = activityFinished;
          if (activityFinished == false) {
            dayFinished = false;
          }
        }
      }

      print('build today'); // leave in to check for loops
      if (dayFinished && activitiesDueToday.isNotEmpty) {
        FredericBackend.instance.messageBus.add(FredericSystemMessage(
            type: FredericSystemMessageType.CalendarDayCompleted,
            description: 'Calendar day completed'));
      }
    }
    profiler.stop();

    return Container(
        padding:
            const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            if (day.day == 1 || index == 0) _CalendarMonthCard(day),
            if (day.day == 1 || index == 0) SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CalendarDayCard(
                    day, activitiesDueToday, dayFinished && currentDayIsToday),
                Expanded(
                  child: Column(
                    children:
                        List<Widget>.generate(activitiesDueToday.length, (i) {
                      return CalendarActivityCard(activitiesDueToday[i],
                          indicator: index == 0,
                          completed: completedActivityToday.isNotEmpty &&
                              completedActivityToday[i]);
                    }),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

class _CalendarMonthCard extends StatelessWidget {
  _CalendarMonthCard(this.day);

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMMM', context.locale.toString());
    return FredericCard(
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(format.format(day),
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: theme.textColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.6,
                  fontSize: 15)),
          SizedBox(width: 8),
          Text('${day.year}',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: theme.textColor,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.6,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class CalendarActivityCard extends StatelessWidget {
  CalendarActivityCard(this.activity,
      {this.completed = false, this.indicator = false, this.onTap});

  final FredericWorkoutActivity activity;
  final bool indicator;
  final bool completed;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16, left: 8),
      height: 96,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CalendarTimeLine(
            isActive: indicator,
            activeColor: completed ? theme.positiveColor : theme.mainColor,
          ),
          SizedBox(width: 8),
          Expanded(
              child: CalendarActivityCardContent(activity,
                  onClick: onTap,
                  state: completed
                      ? ActivityCardState.Green
                      : ActivityCardState.Normal))
        ],
      ),
    );
  }
}

class CalendarTimeLine extends StatelessWidget {
  CalendarTimeLine(
      {this.isActive = false, this.finished = false, Color? activeColor}) {
    this.activeColor = activeColor ?? theme.mainColor;
    disabledColor = theme.disabledGreyColor;
    this.finishedColor = theme.positiveColor;
  }

  final bool isActive;
  final bool finished;

  late final Color activeColor;
  late final Color disabledColor;
  late final Color finishedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: !isActive
                ? finished
                    ? [
                        circle(finishedColor, 8),
                        circle(finishedColor.withOpacity(0.1), 16)
                      ]
                    : [
                        circle(disabledColor, 10),
                        circle(Colors.white, 6),
                        circle(Colors.transparent, 16)
                      ]
                : [
                    circle(activeColor, 8),
                    circle(activeColor.withOpacity(0.1), 16)
                  ],
          ),
          SizedBox(height: 4),
          Expanded(
            child: Container(
              width: 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: !isActive
                          ? finished
                              ? [finishedColor, finishedColor.withAlpha(0)]
                              : [disabledColor, disabledColor.withAlpha(0)]
                          : [activeColor, activeColor.withAlpha(0)]),
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

class _CalendarDayCard extends StatelessWidget {
  ///
  /// For some reason, when this.completed is an optional argument,
  /// the app throws an error when rendering this widget, but only
  /// when tracking the widget rebuilds in flutter performance
  ///
  /// very odd
  ///
  _CalendarDayCard(this.day, this.activities, this.completed);
  final DateTime day;
  final completed;
  final List<FredericWorkoutActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 66,
          width: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: completed
                  ? theme.positiveColorLight
                  : (theme.isDark
                      ? theme.cardBackgroundColor
                      : theme.mainColorLight)),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                      color: completed
                          ? theme.positiveColor
                          : theme.mainColorInText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text('${getWeekdayName(day.weekday)}',
                    style: TextStyle(
                        color: completed
                            ? theme.positiveColor
                            : theme.mainColorInText,
                        fontSize: 12,
                        fontWeight: FontWeight.w300))
              ]),
        ),
        if (!completed && activities.isNotEmpty)
          FredericCard(
            height: 32,
            width: 56,
            borderRadius: 8,
            borderWidth: 0,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider<FredericSetManager>.value(
                        value: BlocProvider.of<FredericSetManager>(context),
                        child: WorkoutPlayerScreen(activities: activities)))),
            color:
                theme.isDark ? theme.cardBackgroundColor : theme.mainColorLight,
            margin: EdgeInsets.only(top: 12),
            child: Center(
                child: Icon(Icons.play_arrow_outlined,
                    color: theme.mainColorInText)),
          ),
      ],
    );
  }

  String getWeekdayName(int index) {
    switch (index) {
      case 1:
        return tr('dates.short.monday');
      case 2:
        return tr('dates.short.tuesday');
      case 3:
        return tr('dates.short.wednesday');
      case 4:
        return tr('dates.short.thursday');
      case 5:
        return tr('dates.short.friday');
      case 6:
        return tr('dates.short.saturday');
      case 7:
        return tr('dates.short.sunday');
    }
    return 'Err';
  }
}
