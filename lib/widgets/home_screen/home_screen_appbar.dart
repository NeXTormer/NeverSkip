import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/settings_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
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
      title: 'Let\'s find you a Workout',
      subtitle: 'Good $timeOfDay, $userName!',
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        return 'Morning';
      case 10:
      case 12:
      case 13:
      case 14:
        return 'Day';
      case 15:
      case 16:
      case 17:
      case 18:
        return 'Afternoon';
      case 19:
      case 20:
      case 21:
      case 22:
      case 23:
        return 'Evening';
      default:
        return 'Day';
    }
  }
}
