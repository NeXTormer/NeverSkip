import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/settings_screen/settings_element.dart';
import 'package:frederic/widgets/settings_screen/settings_segment.dart';
import 'package:frederic/widgets/settings_screen/user_settings_segment.dart';
import 'package:frederic/widgets/standard_elements/basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) => CustomScrollView(
          slivers: [
            BasicAppBar(
              title: 'Settings',
              subtitle: 'Make it fit your needs perfectly',
              icon: ExtraIcons.settings,
            ),
            if (theme.isBright) SliverDivider(),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
            UserSettingsSegment(user),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(title: 'App Settings', elements: <SettingsElement>[
              SettingsElement(
                text: 'Werner',
                subText: 'Enabled',
                icon: Icons.description,
              ),
              SettingsElement(
                text: 'Werner',
                subText: 'Enabled',
                icon: Icons.description,
              ),
              SettingsElement(text: 'Reminder Notifications', hasSwitch: true),
              SettingsElement(
                text: 'Werner',
                subText: 'Enabled',
                icon: Icons.description,
              ),
            ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(title: 'Preferences', elements: <SettingsElement>[
              SettingsElement(
                text: 'Werner',
                subText: 'Enabled',
                icon: Icons.description,
              ),
              SettingsElement(
                text: 'Werner',
                subText: 'Enabled',
                icon: Icons.description,
              ),
              SettingsElement(text: 'Reminder Notifications', hasSwitch: true),
              SettingsElement(
                text: 'Werner',
                subText: 'Enabled',
                icon: Icons.description,
              ),
            ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            if (kDebugMode)
              SettingsSegment(title: 'Debug', elements: <SettingsElement>[
                SettingsElement(
                  text: 'Show profiling data',
                  icon: Icons.speed,
                  changerTitle: 'Profiling data',
                  changeAttributeWidget: FredericProfiler.evaluateAsWidget(),
                ),
              ])
          ],
        ),
      ),
    );
  }
}
