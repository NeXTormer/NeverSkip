import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/frederic_text_theme.dart';

class FredericSliverAppBar extends StatelessWidget {
  FredericSliverAppBar({
    required this.title,
    this.height = 72,
    this.subtitle,
    this.icon,
    this.trailing,
    this.leading,
    Key? key,
  }) : super(key: key) {
    rounded = theme.isColorful;
  }

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final Widget? leading;

  late final bool rounded;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        delegate: _FredericSliverAppBarHeaderDelegate(
            title: title,
            subtitle: subtitle,
            icon: icon,
            trailing: trailing,
            leading: leading,
            rounded: rounded,
            height: height));
  }
}

class _FredericSliverAppBarHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  _FredericSliverAppBarHeaderDelegate({
    required this.title,
    required this.rounded,
    required this.height,
    this.subtitle,
    this.icon,
    this.trailing,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final Widget? leading;

  final bool rounded;
  final double height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
          borderRadius: rounded
              ? BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))
              : null),
      child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leading != null) leading!,
              Container(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(subtitle ?? '',
                              style: FredericTextTheme.homeScreenAppBarTitle),
                          SizedBox(height: 8),
                          Text(title,
                              style:
                                  FredericTextTheme.homeScreenAppBarSubTitle),
                          SizedBox(height: 4),
                        ],
                      ),
                      if (icon != null) icon!
                      // Icon(
                      //   icon!,
                      //   color: theme.isColorful ? Colors.white : theme.mainColor,
                      // )
                    ]),
              ),
              if (trailing != null) trailing!,
            ],
          )),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(
      covariant _FredericSliverAppBarHeaderDelegate oldDelegate) {
    return false;
  }
}
