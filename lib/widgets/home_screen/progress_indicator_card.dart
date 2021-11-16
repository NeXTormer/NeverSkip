import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/main.dart';
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
    double bestProgress = (activity?.type == FredericActivityType.Weighted
            ? sets.bestWeight
            : sets.bestReps)
        .toDouble();
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
                      FredericBackend.instance.userManager.state
                          .progressMonitors = monitors;
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
                      padding: const EdgeInsets.only(left: 10),
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
                      aspectRatio: 1,
                      child: PictureIcon(activity!.image,
                          mainColor: theme.mainColorInText)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              activity!.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: theme.greyTextColor,
                                  fontSize: 10,
                                  letterSpacing: 0.3),
                            ),
                          ),
                          UnitText('$bestProgress', activity!.progressUnit)
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
