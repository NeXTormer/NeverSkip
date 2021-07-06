import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:intl/intl.dart';

class SetCard extends StatelessWidget {
  const SetCard(this.set, this.activity);

  final FredericSet set;
  final FredericActivity? activity;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kMainColorLight),
              child: Icon(
                ExtraIcons.statistics,
                color: kMainColor,
                size: 18,
              ),
            ),
            SizedBox(width: 16),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  '${set.reps}',
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: 14),
                ),
                SizedBox(width: 3),
                Text('reps',
                    style: TextStyle(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        fontSize: 12)),
                SizedBox(width: 10),
                FredericVerticalDivider(length: 16),
                SizedBox(width: 10),
                Text(
                  '${set.weight}',
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: 14),
                ),
                SizedBox(width: 3),
                Text(activity!.progressUnit!,
                    style: TextStyle(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        fontSize: 12)),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              '${DateFormat.yMMMd().format(set.timestamp.toLocal())}',
              style: TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  fontSize: 14),
            ),
            SizedBox(width: 8),
            Text(
              '${DateFormat.Hm().format(set.timestamp.toLocal())}',
              style: TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                  fontSize: 14),
            ),
            SizedBox(width: 12),
            Icon(ExtraIcons.calendar, color: kMainColor, size: 22),
          ],
        ));
  }
}
