import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/settings_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

class HomeScreenAppbar extends StatelessWidget {
  HomeScreenAppbar(this.user);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return FredericSliverAppBar(
      height: 124,
      title: 'Let\'s find you a Workout',
      subtitle: 'Good Morning, ${user.name.split(' ').first}',
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(user.image),
          ),
          StreakIcon(user: user),
        ],
      ),
      icon: FredericContainerTransition(
          tappable: true,
          closedBorderRadius: 8,
          transitionType: ContainerTransitionType.fadeThrough,
          childBuilder: (context, openContainer) {
            return Container(
                height: 32,
                width: 32,
                color: theme.isColorful ? Colors.white : theme.mainColor,
                child: Icon(
                  ExtraIcons.settings,
                  color: theme.isColorful ? theme.mainColor : Colors.white,
                  size: 18,
                ));
          },
          expandedChild: SettingsScreen()),
    );
  }
}
