import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/circular_plus_icon.dart';

import '../../../backend/activities/frederic_activity.dart';
import '../../../main.dart';
import '../frederic_card.dart';
import '../picture_icon.dart';

class NormalActivityCardContent extends StatelessWidget {
  NormalActivityCardContent(this.activity, this.onClick,
      {this.addButton = false, Key? key})
      : super(key: key);

  final FredericActivity activity;
  final void Function()? onClick;
  final bool addButton;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      onTap: addButton ? null : onClick,
      height: 60,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
              width: 40,
              height: 40,
              child: AspectRatio(
                  aspectRatio: 1, child: PictureIcon(activity.image))),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity.name}',
                  style: TextStyle(
                    color: theme.textColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(
                          color: const Color(0xC03A3A3A),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                          fontSize: 12),
                      text: '${activity.description}'),
                ),
              ],
            ),
          ),
          if (addButton && onClick != null)
            GestureDetector(
              onTap: onClick,
              child: Container(
                width: 40,
                child: CircularPlusIcon(),
              ),
            ),
        ],
      ),
    );
  }
}
