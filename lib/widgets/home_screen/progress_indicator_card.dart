import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/misc/frederic_text_theme.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/unit_text.dart';
import 'package:shimmer/shimmer.dart';

class ProgressIndicatorCard extends StatelessWidget {
  ProgressIndicatorCard(this.sets, this.activity);

  final FredericSetList sets;
  final FredericActivity? activity;

  @override
  Widget build(BuildContext context) {
    bool loading = activity == null;
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
                      FredericBackend.instance.userManager.progressMonitors =
                          monitors;
                      Navigator.of(context).pop();
                    },
                    destructiveAction: true,
                    title: 'Confirm deletion',
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          'Do you want to delete the personal record display? This cannot be undone!',
                          textAlign: TextAlign.center),
                    ),
                  ));
        },
        padding: EdgeInsets.all(10),
        child: loading
            ? Shimmer.fromColors(
                enabled: loading,
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    AspectRatio(aspectRatio: 1, child: PictureIcon(null)),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.black54,
                            height: 10,
                            width: 80,
                            margin: EdgeInsets.only(left: 2),
                          ),
                          Container(
                              color: Colors.black54,
                              height: 18,
                              width: 42,
                              margin: EdgeInsets.only(left: 2)),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Row(
                children: [
                  AspectRatio(
                      aspectRatio: 1, child: PictureIcon(activity!.image)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activity!.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FredericTextTheme.cardTitleSmall,
                          ),
                          UnitText('${sets.bestProgress}', sets.progressType)
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
