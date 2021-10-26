import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
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
    return FredericScaffold(
      body: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FredericBasicAppBar(
                title: 'User Settings',
                subtitle: 'Manage your User Account',
              ),
            ),
            if (theme.isBright) SliverDivider(),
            SliverPadding(
              padding: const EdgeInsets.only(top: 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 150,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: theme.mainColorLight,
                      radius: 60,
                      backgroundImage: CachedNetworkImageProvider(user.image),
                    ),
                  ),
                ),
              ),
            ),
            SettingsSegment(title: 'Your Data', elements: <SettingsElement>[
              SettingsElement(
                text: 'Name',
                icon: Icons.drive_file_rename_outline,
                subText: user.name,
                changerTitle: 'Update your name',
                infoText:
                    'Your name will be visible to everyone when your profile is discoverable and to your friends.',
                changeAttributeWidget: TextAttributeChanger(
                  placeholder: 'Name',
                  currentValue: () => user.name,
                  updateValue: (newValue) => user.name = newValue,
                ),
              ),
              SettingsElement(
                text: 'Username',
                subText: user.username,
                icon: Icons.supervised_user_circle_outlined,
                changerTitle: 'Update your username',
                infoText:
                    'Others can find your profile using your username if your profile is discoverable. You can change your username every month. It must be unique.',
                changeAttributeWidget: TextAttributeChanger(
                  placeholder: 'Username',
                  currentValue: () => user.username,
                  updateValue: (newValue) => user.username = newValue,
                ),
              ),
              SettingsElement(
                text: 'Profile Picture',
                changerTitle: 'Upload a new Profile Picture',
                icon: Icons.person,
                changeAttributeWidget: ImageAttributeChanger(
                    currentValue: () => user.image,
                    updateValue: (imageFile) =>
                        user.updateProfilePicture(imageFile)),
              ),
              SettingsElement(
                  text: 'Date of Birth',
                  subText: user.birthdayFormatted,
                  infoText:
                      'Your birthday is used to calculate your current age.',
                  changerTitle: 'Update your birthday',
                  changeAttributeWidget: DateTimeAttributeChanger(
                    currentValue: () => user.birthday,
                    updateValue: (newDate) => user.birthday = newDate,
                  ),
                  icon: Icons.cake_outlined),
              SettingsElement(
                text: 'E-Mail Address',
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
                      title: 'Privacy Settings',
                      elements: <SettingsElement>[
                        SettingsElement(
                            text: 'Discoverable by others',
                            icon: Icons.security,
                            hasSwitch: true,
                            defaultSwitchPosition: true),
                        SettingsElement(
                            text: 'Publish Streak',
                            icon: Icons.local_fire_department_outlined,
                            defaultSwitchPosition: true,
                            hasSwitch: true),
                        SettingsElement(
                            text: 'Manage Friends',
                            icon: Icons.people,
                            subText: '7 Friends'),
                        SettingsElement(
                          text: 'Share Anonymous Analytics',
                          icon: Icons.analytics_outlined,
                          hasSwitch: true,
                          defaultSwitchPosition:
                              preferences.data?.getBool('collect-analytics'),
                          onChanged: (value) async {
                            if (value == false) {
                              return await FredericActionDialog.show(
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
                                          })) ??
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
            SettingsSegment(title: 'Actions', elements: <SettingsElement>[
              SettingsElement(
                  text: 'Sign Out',
                  icon: Icons.exit_to_app,
                  onTap: () {
                    FredericBackend.instance.userManager.signOut(context);
                  }),
              SettingsElement(
                text: 'Change Password',
                changerTitle: 'Change your Password',
                icon: Icons.vpn_key_outlined,
                changeAttributeWidget: PasswordChanger(),
              ),
              SettingsElement(
                text: 'Delete Account',
                icon: Icons.delete_forever,
                infoText:
                    'Do you really want to delete your account? This action can not be undone!',
                changerTitle: 'Delete Account',
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
