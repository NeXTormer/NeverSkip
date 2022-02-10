import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';

class ShortSetCard extends StatelessWidget {
  const ShortSetCard(
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
                        borderRadius: BorderRadius.circular(8),
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
                      Text('Done!',
                          style: TextStyle(
                              color: theme.textColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 14)),
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
                    if (!last && finished)
                      Icon(Icons.delete_outlined, color: theme.greyTextColor)
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
