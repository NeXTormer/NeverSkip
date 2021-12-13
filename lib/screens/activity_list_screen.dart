import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/edit_activity_screen.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_segment.dart';
import 'package:frederic/widgets/activity_screen/activity_list_screen_app_bar.dart';
import 'package:frederic/widgets/activity_screen/activity_list_segment.dart';
import 'package:frederic/widgets/activity_screen/featured_activity_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../state/activity_filter_controller.dart';

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
      child: FredericScaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            CupertinoScaffold.showCupertinoModalBottomSheet(
                enableDrag: true,
                context: context,
                builder: (newContext) {
                  return EditActivityScreen(FredericActivity.create());
                });
          },
          child: Icon(
            Icons.post_add_outlined,
            color: Colors.white,
          ),
          backgroundColor: theme.mainColor,
        ),
        body: BlocBuilder<FredericUserManager, FredericUser>(
          buildWhen: (last, next) =>
              last.progressMonitors != next.progressMonitors,
          builder: (context, user) {
            return Consumer<ActivityFilterController>(
              builder: (context, filter, child) {
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  controller:
                      isSelector ? ModalScrollController.of(context) : null,
                  slivers: [
                    ActivityListScreenAppBar(
                      title,
                      subtitle,
                      user: user,
                      filterController: filter,
                      isSelector: isSelector,
                      onSelect: onSelect,
                    ),
                    FeaturedActivitySegment(
                      'Featured',
                      FredericBackend.instance.defaults.featuredActivities,
                      onTap: onSelect,
                      isSelector: isSelector,
                    ),
                    ActivityFilterSegment(filterController: filter),
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
    );
  }
}
