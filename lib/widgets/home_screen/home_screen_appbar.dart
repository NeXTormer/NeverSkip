import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/purchase_screen.dart';
import 'package:frederic/screens/settings_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

class HomeScreenAppbar extends StatelessWidget {
  HomeScreenAppbar(this.user);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    String userName = user.name.split(' ').first;
    String timeOfDay = getTimeOfDay(DateTime.now());

    return FredericSliverAppBar(
      height: 124,
      title: tr('home.title'),
      subtitle: tr('home.subtitle', args: [timeOfDay, userName]),
      leading: Row(
        children: [
          Stack(
            children: [
              FredericContainerTransition(
                  tappable: true,
                  closedBorderRadius: 32,
                  transitionType: ContainerTransitionType.fadeThrough,
                  onClose: () =>
                      FredericBackend.instance.analytics.logEnterHomeScreen(),
                  childBuilder: (context, openContainer) {
                    return CircleAvatar(
                      radius: 22,
                      foregroundColor: theme.isBright
                          ? Colors.white
                          : theme.textColorColorfulBackground,
                      backgroundColor: theme.isBright
                          ? Colors.white
                          : theme.textColorColorfulBackground,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        foregroundImage: CachedNetworkImageProvider(user.image),
                      ),
                    );
                  },
                  expandedChild: SettingsScreen()),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.settings,
                    size: 18,
                    color: theme.greyColor,
                  ))
            ],
          ),
          Expanded(child: Container()),
          if (user.inTrialMode)
            FredericContainerTransition(
                tappable: true,
                closedBorderRadius: 0,
                closedColor:
                    theme.isColorful ? theme.mainColor : theme.backgroundColor,
                transitionType: ContainerTransitionType.fadeThrough,
                onClose: () =>
                    FredericBackend.instance.analytics.logEnterHomeScreen(),
                childBuilder: (context, openContainer) {
                  return Row(
                    children: [
                      Text(
                        '${user.getTrialDaysLeft() >= 0 ? "${user.getTrialDaysLeft()} days remaining" : "expired"}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: theme.isColorful
                                ? theme.textColorColorfulBackground
                                : theme.textColor),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.monetization_on_outlined,
                          color: theme.isColorful
                              ? theme.textColorColorfulBackground
                              : theme.mainColor,
                          size: 24),
                      const SizedBox(width: 8),
                      FredericVerticalDivider(
                        color: theme.isColorful
                            ? theme.textColorColorfulBackground
                            : theme.greyColor,
                      ),
                    ],
                  );
                },
                expandedChild: PurchaseScreen()),
          StreakIcon(
            user: user,
            onColorfulBackground: theme.isColorful,
          ),
        ],
      ),
    );
  }

  String getTimeOfDay(DateTime time) {
    switch (time.hour) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        return tr('home.time_of_day.morning');
      case 10:
      case 12:
      case 13:
      case 14:
        return tr('home.time_of_day.day');
      case 15:
      case 16:
      case 17:
      case 18:
        return tr('home.time_of_day.afternoon');
      case 19:
      case 20:
      case 21:
      case 22:
      case 23:
        return tr('home.time_of_day.evening');
      default:
        return tr('home.time_of_day.day');
    }
  }
}
