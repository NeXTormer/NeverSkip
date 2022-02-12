import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/settings_screen/account_deleter.dart';
import 'package:frederic/widgets/settings_screen/datetime_attribute_changer.dart';
import 'package:frederic/widgets/settings_screen/image_attribute_changer.dart';
import 'package:frederic/widgets/settings_screen/password_changer.dart';
import 'package:frederic/widgets/settings_screen/settings_element.dart';
import 'package:frederic/widgets/settings_screen/settings_segment.dart';
import 'package:frederic/widgets/settings_screen/text_attribute_changer.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FredericBackend.instance.analytics.logEnterUserSettingsScreen();
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FredericBasicAppBar(
                backButton: true,
                title: tr('settings.account_title'),
                subtitle: tr('settings.account_subtitle'),
              ),
            ),
            if (theme.isMonotone) SliverDivider(),
            SliverPadding(
              padding: const EdgeInsets.only(top: 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 150,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: theme.mainColorLight,
                      radius: 60,
                      backgroundImage: NetworkImage(user.image),
                    ),
                  ),
                ),
              ),
            ),
            SettingsSegment(title: tr('settings.user.your_data'), elements: <
                SettingsElement>[
              SettingsElement(
                text: tr('settings.user.name.title'),
                icon: Icons.drive_file_rename_outline,
                subText: user.name,
                changerTitle: tr('settings.user.name.changer_title'),
                changeAttributeWidget: TextAttributeChanger(
                  placeholder: 'Name',
                  currentValue: () => user.name,
                  updateValue: (newValue) {
                    user.name = newValue;
                    FredericBackend.instance.userManager.userDataChanged();
                  },
                ),
              ),
              // SettingsElement(
              //   text: 'Username',
              //   subText: user.username,
              //   icon: Icons.supervised_user_circle_outlined,
              //   changerTitle: 'Update your username',
              //   infoText:
              //       'Others can find your profile using your username if your profile is discoverable. You can change your username every month. It must be unique.',
              //   changeAttributeWidget: TextAttributeChanger(
              //     placeholder: 'Username',
              //     currentValue: () => user.username,
              //     updateValue: (newValue) {
              //       user.username = newValue;
              //       FredericBackend.instance.userManager.userDataChanged();
              //     },
              //   ),
              // ),
              SettingsElement(
                text: tr('settings.user.picture.title'),
                changerTitle: tr('settings.picture.changer_title'),
                icon: Icons.person,
                changeAttributeWidget: ImageAttributeChanger(
                    currentValue: () => user.image,
                    updateValue: (imageFile) async {
                      bool success = await user.updateProfilePicture(imageFile);
                      if (success) {
                        FredericBackend.instance.userManager.userDataChanged();
                      }
                      return success;
                    }),
              ),
              SettingsElement(
                  text: tr('settings.user.date_of_birth.title'),
                  subText: user.birthdayFormatted,
                  infoText: tr('settings.user.date_of_birth.description'),
                  changerTitle: tr('settings.user.date_of_birth.changer_title'),
                  changeAttributeWidget: DateTimeAttributeChanger(
                    currentValue: () => user.birthday,
                    updateValue: (newDate) {
                      user.birthday = newDate;
                      FredericBackend.instance.userManager.userDataChanged();
                    },
                  ),
                  icon: Icons.cake_outlined),
              SettingsElement(
                text: tr('settings.user.email_address_title'),
                subText: FirebaseAuth.instance.currentUser?.email,
                icon: Icons.mail_outline_rounded,
                clickable: false,
              ),
            ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, preferences) {
                  return SettingsSegment(
                      title: tr('settings.privacy_settings'),
                      elements: <SettingsElement>[
                        // SettingsElement(
                        //     text: 'Discoverable by others',
                        //     icon: Icons.security,
                        //     hasSwitch: true,
                        //     defaultSwitchPosition: true),
                        // SettingsElement(
                        //     text: 'Publish Streak',
                        //     icon: Icons.local_fire_department_outlined,
                        //     defaultSwitchPosition: true,
                        //     hasSwitch: true),
                        // SettingsElement(
                        //     text: 'Manage Friends',
                        //     icon: Icons.people,
                        //     subText: '7 Friends'),
                        SettingsElement(
                          key: UniqueKey(),
                          text: tr('settings.share_analytics'),
                          icon: Icons.analytics_outlined,
                          hasSwitch: true,
                          defaultSwitchPosition: () {
                            bool nodata = preferences.data == null;
                            if (nodata) return null;
                            return preferences.data
                                    ?.getBool('collect-analytics') ??
                                true;
                          }(),
                          onChanged: (value) async {
                            if (value == false) {
                              return (await FredericActionDialog.show(
                                      context: context,
                                      dialog: FredericActionDialog(
                                          title: 'Disable Anonymous Analytics?',
                                          childText:
                                              'Analytics are collected anonymously and are not shared with others.\nThey help us provide you a better experience.',
                                          closeOnConfirm: true,
                                          onConfirm: () {
                                            preferences.data?.setBool(
                                                'collect-analytics', value);
                                            FredericBackend.instance.analytics
                                                .disable();
                                          }))) ??
                                  false;
                            } else {
                              preferences.data
                                  ?.setBool('collect-analytics', value);
                              FredericBackend.instance.analytics.enable();
                              return true;
                            }
                          },
                        ),
                      ]);
                }),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(
                title: tr('settings.actions'),
                elements: <SettingsElement>[
                  SettingsElement(
                      text: tr('settings.user.sign_out.title'),
                      icon: Icons.exit_to_app,
                      onTap: () {
                        FredericActionDialog.show(
                            context: context,
                            dialog: FredericActionDialog(
                                title: tr('settings.user.sign_out.text'),
                                onConfirm: () => FredericBackend
                                    .instance.userManager
                                    .signOut(context)));
                      }),
                  SettingsElement(
                    text: tr('settings.user.change_password.title'),
                    changerTitle:
                        tr('settings.user.change_password.changer_title'),
                    icon: Icons.vpn_key_outlined,
                    changeAttributeWidget: PasswordChanger(),
                  ),
                  SettingsElement(
                    text: tr('settings.user.delete_account.title'),
                    icon: Icons.delete_forever,
                    infoText: tr('settings.user.delete_account.description'),
                    changerTitle:
                        tr('settings.user.delete_account.changer_title'),
                    changeAttributeWidget: AccountDeleter(),
                  ),
                ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
          ],
        ),
      ),
    );
  }
}
