import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/widgets/settings_screen/datetime_attribute_changer.dart';
import 'package:frederic/widgets/settings_screen/settings_element.dart';
import 'package:frederic/widgets/settings_screen/settings_segment.dart';
import 'package:frederic/widgets/settings_screen/text_attribute_changer.dart';
import 'package:frederic/widgets/standard_elements/basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<FredericUserManager, FredericUser>(
        builder: (context, user) => CustomScrollView(
          slivers: [
            BasicAppBar(
              title: 'User Settings',
              subtitle: 'Manage your User Account',
            ),
            SliverDivider(),
            SliverToBoxAdapter(
              child: Container(
                height: 150,
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: CachedNetworkImageProvider(user.image),
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
            ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(
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
                ]),
            SliverPadding(padding: const EdgeInsets.symmetric(vertical: 12)),
            SettingsSegment(title: 'Actions', elements: <SettingsElement>[
              SettingsElement(
                  text: 'Sign Out',
                  icon: Icons.exit_to_app,
                  onTap: () {
                    //FirebaseAuth.instance.signOut();
                    //Phoenix.rebirth(context);
                  }),
              SettingsElement(
                  text: 'Delete Account', icon: Icons.delete_forever),
            ]),
          ],
        ),
      ),
    );
  }
}
