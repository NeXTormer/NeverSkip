import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/onboarding_screen.dart';
import 'package:frederic/widgets/settings_screen/settings_element.dart';
import 'package:frederic/widgets/settings_screen/settings_segment.dart';
import 'package:frederic/widgets/settings_screen/specific_settings/color_theme_changer.dart';
import 'package:frederic/widgets/settings_screen/user_settings_segment.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FredericBackend.instance.analytics.logEnterSettingsScreen();
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FredericBasicAppBar(
                title: 'Settings',
                subtitle: 'Make it fit your needs perfectly',
                icon: FredericAppBarIcon(ExtraIcons.settings),
              ),
            ),
            if (theme.isMonotone) SliverDivider(),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
            UserSettingsSegment(user),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(title: 'Customization', elements: <SettingsElement>[
              SettingsElement(
                text: 'Color Theme',
                subText: theme.name,
                changeAttributeSliver: ColorThemeChanger(),
                changerTitle: 'Change the Color Theme',
                icon: Icons.color_lens_outlined,
              ),
              // SettingsElement(
              //   text: 'Werner',
              //   subText: 'Enabled',
              //   icon: Icons.description,
              // ),
              // SettingsElement(text: 'Reminder Notifications', hasSwitch: true),
              // SettingsElement(
              //   text: 'Werner',
              //   subText: 'Enabled',
              //   icon: Icons.description,
              // ),
            ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(title: 'Preferences', elements: <SettingsElement>[
              SettingsElement(
                text: 'Show introduction',
                clickable: true,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => OnboardingScreen())),
                icon: Icons.add_to_home_screen_outlined,
              ),
              // SettingsElement(
              //   text: 'Werner',
              //   subText: 'Enabled',
              //   icon: Icons.description,
              // ),
              // SettingsElement(text: 'Reminder Notifications', hasSwitch: true),
              // SettingsElement(
              //   text: 'Werner',
              //   subText: 'Enabled',
              //   icon: Icons.description,
              // ),
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
