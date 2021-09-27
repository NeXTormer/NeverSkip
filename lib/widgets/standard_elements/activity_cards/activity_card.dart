import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/add_progress_screen.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/normal_activity_card_content.dart';
import 'package:frederic/widgets/standard_elements/activity_cards/small_activity_card_content.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum ActivityCardType { Calendar, Small, Normal }

enum ActivityCardState { Normal, Green }

///
/// Opens the AddProgressSheet of the activity if clicked and no other onClick
/// function is passed in.
///
class ActivityCard extends StatelessWidget {
  ActivityCard(this.activity,
      {this.type = ActivityCardType.Normal,
      Key? key,
      this.setList,
      this.onClick,
      this.state = ActivityCardState.Normal,
      this.addButton = false,
      Color? mainColor,
      Color? accentColor})
      : super(key: key) {
    this.mainColor = mainColor ?? theme.mainColor;
    this.accentColor = accentColor ?? theme.accentColor;
  }

  final FredericActivity activity;
  final ActivityCardType type;
  final ActivityCardState state;

  final FredericSetList? setList;

  late final Color mainColor;
  late final Color accentColor;

  final bool addButton;

  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    if (type == ActivityCardType.Small)
      return SmallActivityCardContent(
        activity,
        () => handleClick(context),
        key: key,
        setList: setList,
      );
    if (type == ActivityCardType.Normal)
      return NormalActivityCardContent(
        activity,
        () => handleClick(context),
        addButton: addButton,
        key: key,
      );

    return Container(
        color: Colors.redAccent,
        height: 40,
        width: 200,
        child: Center(child: Text("error")));
  }

  void handleClick(BuildContext context) {
    if (onClick != null) return onClick!();
    CupertinoScaffold.showCupertinoModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (newContext) {
          return BlocProvider.value(
              value: BlocProvider.of<FredericSetManager>(context),
              child: AddProgressScreen(activity));
        });
  }
}
