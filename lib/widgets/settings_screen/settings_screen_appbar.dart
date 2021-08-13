import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/misc/frederic_text_theme.dart';

class SettingsScreenAppbar extends StatelessWidget {
  const SettingsScreenAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Make it fit your needs perfectly',
                          style: FredericTextTheme.homeScreenAppBarTitle),
                      SizedBox(height: 8),
                      Text('Settings',
                          style: FredericTextTheme.homeScreenAppBarSubTitle),
                      SizedBox(height: 4),
                    ],
                  ),
                  Icon(
                    ExtraIcons.settings,
                    color: kMainColor,
                  )
                ])));
  }
}
