import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/add_progress_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'frederic_vertical_divider.dart';

class ActivityCard extends StatelessWidget {
  ActivityCard(this.activity, {this.selectable = false, this.onClick});

  final bool selectable;
  final Function? onClick;

  final FredericActivity? activity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FredericCard(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                PictureIcon(activity!.image),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(activity!.name,
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: true
                                        ? kTextColor
                                        : const Color(0x993A3A3A))),
                            Expanded(child: Container()),
                            if (false &&
                                activity!.type ==
                                    FredericActivityType.Weighted &&
                                activity!.bestProgress != 0)
                              Icon(ExtraIcons.dumbbell,
                                  color: kMainColor, size: 16),
                            SizedBox(width: 6),
                            if (activity!.bestProgress != 0)
                              Text(
                                '${activity!.bestProgress}',
                                style: TextStyle(
                                    color: kTextColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    fontSize: 14),
                              ),
                            SizedBox(width: 2),
                            if (activity!.bestProgress != 0)
                              Text(activity!.bestProgressType,
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                      fontSize: 12)),
                          ]),
                      Row(
                        children: [
                          Text(
                            '${activity!.recommendedReps}',
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 14),
                          ),
                          SizedBox(width: 2),
                          Text('reps',
                              style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  fontSize: 12)),
                          SizedBox(width: 6),
                          FredericVerticalDivider(length: 16),
                          SizedBox(width: 6),
                          Text(
                            '${activity!.recommendedSets}',
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 14),
                          ),
                          SizedBox(width: 2),
                          Text('sets',
                              style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  fontSize: 12)),
                          Expanded(
                            child: Container(),
                          ),
                          Icon(ExtraIcons.dots, color: kGreyColor, size: 20)
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.grey.withAlpha(32),
            highlightColor: Colors.grey.withAlpha(15),
            onTap: () => handleClick(context),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent),
                padding: EdgeInsets.all(12)),
          ),
        )
      ],
    );
  }

  void handleClick(BuildContext context) {
    if (selectable) return onClick!();

    showCupertinoModalBottomSheet(
        //expand: true,
        enableDrag: true,
        context: context,
        builder: (context) => AddProgressScreen(activity));
  }
}
