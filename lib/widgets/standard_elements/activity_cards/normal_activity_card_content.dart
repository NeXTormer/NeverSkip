import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/circular_plus_icon.dart';

import '../../../backend/activities/frederic_activity.dart';
import '../../../main.dart';
import '../frederic_card.dart';
import '../frederic_vertical_divider.dart';
import '../picture_icon.dart';

class NormalActivityCardContent extends StatelessWidget {
  NormalActivityCardContent(this.activity);

  final FredericActivity activity;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(width: 40, height: 40, child: PictureIcon(activity.image)),
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
    );
  }
}
