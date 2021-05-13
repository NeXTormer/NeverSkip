import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/misc/frederic_text_theme.dart';

class HomeScreenAppbar extends StatelessWidget {
  HomeScreenAppbar(this.user);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
                Icon(
                  ExtraIcons.bell_1,
                  color: Colors.grey,
                )
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
                GestureDetector(
                  onTap: () => FredericBackend.instance.userManager
                      .add(FredericSignOutEvent('appbar button pressed')),
                  child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kMainColor),
                      child: Icon(
                        ExtraIcons.settings,
                        color: Colors.white,
                        size: 18,
                      )),
                )
              ],
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
