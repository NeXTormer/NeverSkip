import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/misc/frederic_text_theme.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/unit_text.dart';

class ProgressIndicatorCard extends StatelessWidget {
  ProgressIndicatorCard(this.sets, this.activity);

  final FredericSetList sets;
  final FredericActivity? activity;

  @override
  Widget build(BuildContext context) {
    if (activity == null)
      return Container(width: 10, height: 1, color: Colors.red);
    return FredericCard(
        height: 65,
        width: 160,
        onTap: () {},
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => FredericActionDialog(
                    onConfirm: () {
                      var monitors = FredericBackend
                          .instance.userManager.state.progressMonitors;
                      monitors.remove(sets.activityID);
                      //TODO: not working all the time
                      FredericBackend.instance.userManager.progressMonitors =
                          monitors;
                      Navigator.of(context).pop();
                    },
                    destructiveAction: true,
                    title: 'Confirm deletion',
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          'Do you want to delete the personal record display? This cannot be undone!'),
                    ),
                  ));
        },
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            AspectRatio(aspectRatio: 1, child: PictureIcon(activity!.image)),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activity!.name,
                    style: FredericTextTheme.cardTitleSmall,
                  ),
                  UnitText('${sets.bestProgress}', sets.progressType)
                ],
              ),
            )
          ],
        ));
  }
}
