import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_segment.dart';
import 'package:frederic/widgets/activity_screen/activity_header.dart';
import 'package:frederic/widgets/activity_screen/activity_list_segment.dart';
import 'package:frederic/widgets/activity_screen/featured_activity_segment.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../state/activity_filter_controller.dart';
import '../widgets/standard_elements/sliver_divider.dart';

class ActivityListScreen extends StatelessWidget {
  ActivityListScreen(
      {this.isSelector = false,
      this.onSelect,
      this.title = 'All exercises',
      this.subtitle = 'Find an exercise'});

  final bool isSelector;
  final void Function(FredericActivity)? onSelect;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityFilterController>(
      create: (context) => ActivityFilterController(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          child: BlocBuilder<FredericUserManager, FredericUser>(
            buildWhen: (last, next) =>
                last.progressMonitors != next.progressMonitors,
            builder: (context, user) {
              return Consumer<ActivityFilterController>(
                builder: (context, filter, child) {
                  return CustomScrollView(
                    controller:
                        isSelector ? ModalScrollController.of(context) : null,
                    slivers: [
                      ActivityHeader(title, subtitle, user: user),
                      SliverDivider(),
                      FeaturedActivitySegment(
                        'Featured',
                        user.progressMonitors,
                        onTap: onSelect,
                        isSelector: isSelector,
                      ),
                      FeaturedActivitySegment(
                        'Calisthenics',
                        user.progressMonitors,
                        onTap: onSelect,
                        isSelector: isSelector,
                      ),
                      ActivityFilterSegment(
                          filterController:
                              filter), // TODO Update Muscle Buttons to Radio Buttons
                      ActivityListSegment(
                        filterController: filter,
                        onTap: onSelect,
                        isSelector: isSelector,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
