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
      this.addButton = false,
      this.mainColor = kMainColor,
      this.accentColor = kAccentColor});

  final FredericActivity activity;
  final ActivityCardType type;

  final Color mainColor;
  final Color accentColor;

  final bool addButton;

  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    if (type == ActivityCardType.Calendar)
      return CalendarActivityCardContent(activity, () => handleClick(context));
    if (type == ActivityCardType.Small)
      return SmallActivityCardContent(activity, () => handleClick(context));
    if (type == ActivityCardType.Normal)
      return NormalActivityCardContent(activity, () => handleClick(context),
          addButton: addButton);
    if (type == ActivityCardType.WorkoutEditor)
      return CalendarActivityCardContent(activity, () => handleClick(context),
          deleteButton: true);

    return Container(
        color: Colors.redAccent,
        height: 40,
        width: 200,
        child: Center(child: Text("error")));
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
