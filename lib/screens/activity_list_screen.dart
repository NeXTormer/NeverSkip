import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/bottom_sheet.dart';
import 'package:frederic/screens/edit_activity_screen.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_segment.dart';
import 'package:frederic/widgets/activity_screen/activity_list_screen_app_bar.dart';
import 'package:frederic/widgets/activity_screen/activity_list_segment.dart';
import 'package:frederic/widgets/activity_screen/featured_activity_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:provider/provider.dart';

import '../state/activity_filter_controller.dart';

class ActivityListScreen extends StatelessWidget {
  ActivityListScreen({
    this.isSelector = false,
    this.onSelect,
    String? title,
    String? subtitle,
  })  : this.title = tr(title ?? 'exercises.title'),
        this.subtitle = tr(subtitle ?? 'exercises.subtitle');

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
          key: ValueKey<String>('fab_activitylistscreen'),
          onPressed: () => showFredericBottomSheet(
              enableDrag: true,
              context: context,
              builder: (newContext) {
                return EditActivityScreen(FredericActivity.create(
                    FredericBackend.instance.userManager.state.id));
              }),
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
                      tr('exercises.featured'),
                      FredericBackend.instance.defaults.featuredActivities,
                      onTap: onSelect,
                    ),
                    ActivityFilterSegment(filterController: filter),
                    ActivityListSegment(
                      isSelector: isSelector,
                      filterController: filter,
                      onTap: onSelect,
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
