import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/screens/edit_activity_screen.dart';
import 'package:frederic/widgets/standard_elements/circular_plus_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../backend/activities/frederic_activity.dart';
import '../../../main.dart';
import '../frederic_card.dart';
import '../picture_icon.dart';

class NormalActivityCardContent extends StatelessWidget {
  NormalActivityCardContent(this.activity, this.onClick,
      {this.addButton = false, this.onLongPress, Key? key})
      : super(key: key);

  final FredericActivity activity;
  final void Function()? onClick;
  final void Function(BuildContext)? onLongPress;
  final bool addButton;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      onTap: addButton ? null : onClick,
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!(context);
          return;
        }
        if (!activity.isGlobalActivity) {
          CupertinoScaffold.showCupertinoModalBottomSheet(
              context: context, builder: (c) => EditActivityScreen(activity));
        }
      },
      height: 60,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
              width: 40,
              height: 40,
              child: AspectRatio(
                  aspectRatio: 1,
                  child: PictureIcon(
                    activity.image,
                    mainColor: theme.mainColorInText,
                  ))),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${activity.getNameLocalized(context.locale.languageCode)}',
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                        fontSize: 13,
                      ),
                    ),
                    if (!activity.isGlobalActivity)
                      Icon(
                        Icons.app_registration_outlined,
                        color: theme.mainColor,
                        size: 16,
                      )
                  ],
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(
                          color: theme.greyTextColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                          fontSize: 12),
                      text:
                          '${activity.getDescriptionLocalized(context.locale.languageCode)}'),
                ),
              ],
            ),
          ),
          if (addButton && (onClick != null))
            GestureDetector(
              onTap: onClick,
              onLongPress:
                  onLongPress == null ? null : () => onLongPress!(context),
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
