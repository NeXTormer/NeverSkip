import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/misc/frederic_text_theme.dart';
import 'package:frederic/screens/settings_screen.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

class HomeScreenAppbar extends StatelessWidget {
  HomeScreenAppbar(this.user);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(user.image),
                  ),
                  StreakIcon(user: user),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning, ${user.name.split(' ')[0]}!',
                          style: FredericTextTheme.homeScreenAppBarTitle),
                      SizedBox(height: 8),
                      Text('Let\'s find you a workout',
                          style: FredericTextTheme.homeScreenAppBarSubTitle)
                    ],
                  ),
                  FredericContainerTransition(
                      tappable: true,
                      closedBorderRadius: 8,
                      transitionType: ContainerTransitionType.fadeThrough,
                      childBuilder: (context, openContainer) {
                        return Container(
                            height: 32,
                            width: 32,
                            color: theme.isColorful
                                ? Colors.white
                                : theme.mainColor,
                            child: Icon(
                              ExtraIcons.settings,
                              color: theme.isColorful
                                  ? theme.mainColor
                                  : Colors.white,
                              size: 18,
                            ));
                      },
                      expandedChild: SettingsScreen())
                ],
              ),
              SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }
}
