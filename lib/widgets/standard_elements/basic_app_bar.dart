import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/frederic_text_theme.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({required this.title, this.subtitle, this.icon, Key? key})
      : super(key: key);

  final String title;
  final String? subtitle;
  final IconData? icon;

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
                      Text(subtitle ?? '',
                          style: FredericTextTheme.homeScreenAppBarTitle),
                      SizedBox(height: 8),
                      Text(title,
                          style: FredericTextTheme.homeScreenAppBarSubTitle),
                      SizedBox(height: 4),
                    ],
                  ),
                  if (icon != null)
                    Icon(
                      icon!,
                      color: kMainColor,
                    )
                ])));
  }
}
