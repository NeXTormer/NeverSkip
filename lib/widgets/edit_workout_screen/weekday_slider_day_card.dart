import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

///
/// Contains the two designs (whether selected or not)
/// of the WeekDaysSliderDayButton.
///
class WeekDaysSliderDayCard extends StatelessWidget {
  WeekDaysSliderDayCard(
      {required this.dayIndex,
      required this.selectedDate,
      required this.date,
      this.isDraggable = false,
      this.onSwap,
      this.dayWidth});

  final void Function(int first, int second)? onSwap;
  final int dayIndex;
  final int selectedDate;
  final DateTime date;
  final double? dayWidth;
  final bool isDraggable;

  @override
  Widget build(BuildContext context) {
    Widget contents = buildContents(context, false, false, false);
    if (!isDraggable) return contents;
    return DragTarget<int>(
      builder: (ctx, candidates, rejected) {
        if (candidates.isNotEmpty) {
          if (candidates.first != dayIndex)
            return buildContents(context, true, false, false);
        }
        return LongPressDraggable<int>(
            data: dayIndex,
            maxSimultaneousDrags: 1,
            hapticFeedbackOnStart: true,
            child: buildContents(context, false, false, false),
            childWhenDragging: buildContents(context, false, false, true),
            feedback: Material(
                color: Colors.transparent,
                child: buildContents(context, false, true, false)));
      },
      onAcceptWithDetails: (data) {
        onSwap?.call(data.data, dayIndex);
      },
    );
  }

  Widget buildContents(
      BuildContext context, bool colored, bool expanded, bool empty) {
    var width =
        dayWidth ?? (MediaQuery.of(context).size.width / (expanded ? 11 : 10));

    bool selected = selectedDate == dayIndex;
    return Stack(
      children: [
        if (colored)
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.swap_horiz_rounded,
              color: theme.greyTextColor,
              size: 16,
            ),
          ),
        Container(
          //key: UniqueKey(),
          width: width,
          height: expanded ? 44 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: empty
                ? Border.all(color: theme.cardBorderColor)
                : (selected
                    ? Border.all(
                        color: theme.isBright
                            ? theme.mainColor
                            : theme.accentColor)
                    : null),
            color: colored
                ? theme.positiveColor.withOpacity(0.3)
                : selected
                    ? theme.mainColor.withOpacity(0.1)
                    : (expanded
                        ? theme.cardBackgroundColor.withOpacity(0.5)
                        : theme.cardBackgroundColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!empty)
                Text('${date.day}',
                    style: TextStyle(
                      color: selected ? theme.mainColorInText : theme.textColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      fontSize: 17,
                    )),
              if (!empty)
                Text(
                  '${numToWeekday(date.weekday)}',
                  style: TextStyle(
                    color: selected
                        ? theme.mainColorInText.withOpacity(0.7)
                        : theme.textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    fontSize: 13,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  String numToWeekday(num number) {
    switch (number % 7) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return number.toString();
    }
  }
}
