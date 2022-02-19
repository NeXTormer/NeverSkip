import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/onboarding_screen.dart';
import 'package:frederic/widgets/settings_screen/feedback_sender_widget.dart';
import 'package:frederic/widgets/settings_screen/reload_caches_from_db_dialog.dart';
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
                title: tr('settings.title'),
                subtitle: tr('settings.subtitle'),
                icon: FredericAppBarIcon(ExtraIcons.settings),
              ),
            ),
            if (theme.isMonotone) SliverDivider(),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
            UserSettingsSegment(user),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(
                title: tr('settings.customization'),
                elements: <SettingsElement>[
                  SettingsElement(
                    text: tr('settings.color_theme.title'),
                    subText: theme.name,
                    changeAttributeSliver: ColorThemeChanger(),
                    changerTitle: tr('settings.color_theme.changer_title'),
                    icon: Icons.color_lens_outlined,
                  ),
                ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(
                title: tr('settings.preferences'),
                elements: <SettingsElement>[
                  SettingsElement(
                    text: tr('settings.show_onboarding'),
                    clickable: true,
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (c) => OnboardingScreen())),
                    icon: Icons.add_to_home_screen_outlined,
                  ),
                ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(
                title: tr('settings.actions'),
                elements: <SettingsElement>[
                  SettingsElement(
                    text: tr('settings.reload_caches.title'),
                    clickable: true,
                    onTap: () => ReloadCachesFromDBDialog.show(
                        context: context, dialog: ReloadCachesFromDBDialog()),
                    icon: Icons.refresh_rounded,
                  ),
                  SettingsElement(
                    text: tr('settings.feedback.title'),
                    icon: Icons.feedback_outlined,
                    changerTitle: tr('settings.feedback.title'),
                    changeAttributeWidget: FeedbackSenderWidget(user),
                  ),
                  SettingsElement(
                    text: tr('settings.reset_app.title'),
                    clickable: true,
                    onTap: () => ReloadCachesFromDBDialog.show(
                        context: context, dialog: ReloadCachesFromDBDialog()),
                    icon: Icons.settings_backup_restore,
                  ),
                ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            if (kDebugMode || user.isDeveloper)
              SettingsSegment(title: 'Debug', elements: <SettingsElement>[
                SettingsElement(
                  text: 'Show profiling data',
                  icon: Icons.speed,
                  changerTitle: 'Profiling data',
                  changeAttributeWidget: FredericProfiler.evaluateAsWidget(),
                ),
                SettingsElement(
                  text: 'Crash the app',
                  icon: Icons.fire_extinguisher,
                  onTap: () => FirebaseCrashlytics.instance.crash(),
                ),
              ])
          ],
        ),
      ),
    );
  }
}
