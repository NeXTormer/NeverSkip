import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/circular_plus_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../backend/activities/frederic_activity.dart';
import '../../main.dart';
import '../../screens/add_progress_screen.dart';
import '../standard_elements/frederic_card.dart';
import '../standard_elements/frederic_vertical_divider.dart';
import '../standard_elements/picture_icon.dart';

class ActivityListCard extends StatelessWidget {
  ActivityListCard(this.activity, {this.selectable = false, this.onClick});

  final FredericActivity activity;
  final bool selectable;
  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 8),
      child: GestureDetector(
        onTap: () => handleClick(context),
        child: FredericCard(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                  width: 40, height: 40, child: PictureIcon(activity.image)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${activity.name}',
                          style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 6),
                        FredericVerticalDivider(length: 16),
                        SizedBox(width: 6),
                        Text(
                          '${1}', // activity.bestreps
                          style: TextStyle(
                              color: kGreyColor, // TODO Change to darker grey
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(
                              color: kGreyColor, // TODO Change to darker grey
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12),
                          text: '${activity.description}'),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                child: CircularPlusIcon(onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
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
