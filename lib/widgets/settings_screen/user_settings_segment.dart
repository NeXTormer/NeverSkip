import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/user_settings_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

class UserSettingsSegment extends StatelessWidget {
  const UserSettingsSegment(this.user, {Key? key}) : super(key: key);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FredericContainerTransition(
        closedBorderRadius: 8,
        expandedChild: UserSettingsScreen(),
        childBuilder: (context, openContainer) => FredericCard(
          onTap: openContainer,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.mainColorLight,
                  foregroundImage: CachedNetworkImageProvider(user.image),
                  radius: 35,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 6, bottom: 6, left: 12, right: 2),
                    child: Container(
                      //color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 22),
                          ),
                          SizedBox(height: 4),
                          Text(
                            tr('settings.account_subtitle'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: theme.greyColor)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
