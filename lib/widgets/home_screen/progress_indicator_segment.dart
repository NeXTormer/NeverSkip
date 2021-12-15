import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/screens/activity_list_screen.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProgressIndicatorSegment extends StatelessWidget {
  ProgressIndicatorSegment({this.sidePadding = 16});

  final double sidePadding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 8),
          child: FredericHeading('Personal records',
              icon: Icons.add,
              onPressed: () => addNewProgressIndicator(context)),
        ),
        BlocBuilder<FredericActivityManager, FredericActivityListData>(
            builder: (context, activityListData) {
          return BlocBuilder<FredericUserManager, FredericUser>(
              builder: (context, user) {
            return BlocBuilder<FredericSetManager, FredericSetListData>(
                buildWhen: (current, next) => next.changedActivities
                    .any((element) => user.progressMonitors.contains(element)),
                builder: (context, setData) {
                  List<FredericSetList> activities = <FredericSetList>[];
                  for (String activityID in user.progressMonitors) {
                    activities.add(setData[activityID]);
                  }
                  return Container(
                    height: 60,
                    child: ListView.builder(
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: activities.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 16 : 12,
                                right:
                                    index == (activities.length - 1) ? 16 : 0),
                            child: ProgressIndicatorCard(
                                activities[index],
                                activityListData
                                    .activities[activities[index].activityID]),
                          );
                        }),
                  );
                });
          });
        })
      ],
    ));
  }

  void addNewProgressIndicator(BuildContext context) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (ctx) => BlocProvider.value(
            value: BlocProvider.of<FredericSetManager>(context),
            child: ActivityListScreen(
              isSelector: true,
              onSelect: (activity) {
                FredericBackend.instance.userManager
                    .addProgressMonitor(activity.id);
                Navigator.of(context).pop();
              }, //TODO:
              // else {
              //   showDialog(
              //       context: context,
              //       builder: (ctx) => FredericActionDialog(
              //             title: 'This activity is already monitored.',
              //             infoOnly: true,
              //             onConfirm: () => Navigator.of(ctx).pop(),
              //           ));
              // }

              title: 'All exercises',
              subtitle: 'Select a new personal record display',
            )));
  }
}
