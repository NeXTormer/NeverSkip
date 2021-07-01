import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/add_progress_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/calendar_activity_card_content.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/normal_activity_card_content.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/small_activity_card_content.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum ActivityCardType { Calendar, Small, Normal, WorkoutEditor }

///
/// onClick is null: when clicked open AddProgressSheet
///
class ActivityCard extends StatelessWidget {
  ActivityCard(this.activity,
      {this.type = ActivityCardType.Normal,
      this.onClick,
      this.mainColor = kMainColor,
      this.accentColor = kAccentColor});

  final FredericActivity activity;
  final ActivityCardType type;

  final Color mainColor;
  final Color accentColor;

  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        if (type == ActivityCardType.Calendar)
          CalendarActivityCardContent(activity),
        if (type == ActivityCardType.Small) SmallActivityCardContent(activity),
        if (type == ActivityCardType.Normal)
          NormalActivityCardContent(activity),
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
    if (onClick != null) return onClick!();

    showCupertinoModalBottomSheet(
        //expand: true,
        enableDrag: true,
        context: context,
        builder: (context) => AddProgressScreen(activity));
  }
}
