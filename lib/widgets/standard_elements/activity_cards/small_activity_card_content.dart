import 'package:flutter/material.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';

import '../../../backend/backend.dart';
import '../../../main.dart';
import '../frederic_card.dart';
import '../picture_icon.dart';

class SmallActivityCardContent extends StatelessWidget {
  SmallActivityCardContent(this.activity, this.onClick,
      {Key? key, required this.setList})
      : super(key: key);

  final FredericActivity activity;
  final FredericSetList? setList;
  final void Function()? onClick;

  @override
  Widget build(BuildContext context) {
    double bestProgress = (activity.type == FredericActivityType.Weighted
                ? setList?.bestWeight
                : setList?.bestReps)
            ?.toDouble() ??
        0.toDouble();
    return FredericCard(
      onTap: onClick,
      width: MediaQuery.of(context).size.width / 2.3,
      height: 70,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: PictureIcon(activity.image,
                  mainColor: theme.mainColorInText)),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    activity.name,
                    style: TextStyle(
                        color: theme.greyTextColor,
                        fontSize: 10,
                        letterSpacing: 0.3),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${bestProgress.truncateToDouble() == bestProgress ? bestProgress.toInt() : bestProgress}',
                      style: TextStyle(
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: 16),
                    ),
                    SizedBox(width: 2),
                    Text(activity.progressUnit,
                        style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: 14))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
