import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericBasicAppBar extends StatelessWidget {
  FredericBasicAppBar(
      {required this.title,
      this.subtitle,
      this.leadingIcon,
      this.backButton = false,
      this.bottomPadding = 16,
      this.topPadding = 20,
      this.icon,
      this.extraSpace,
      this.height,
      bool? rounded,
      Key? key})
      : super(key: key) {
    this.rounded = rounded ?? theme.isColorful;
  }

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? leadingIcon;
  final double bottomPadding;
  final double topPadding;
  final double? height;
  late final bool rounded;
  final bool backButton;
  final Widget? extraSpace;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
          borderRadius: rounded
              ? BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))
              : null),
      child: Padding(
          padding: EdgeInsets.only(
              left: 16, right: 16, top: topPadding, bottom: bottomPadding),
          child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                if (backButton)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        padding: const EdgeInsets.only(left: 2, right: 4),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: theme.textColorColorfulBackground,
                          size: 21,
                        )),
                  ),
                if (leadingIcon != null) leadingIcon!,
                if (leadingIcon != null) SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subtitle != null)
                        Text(subtitle!,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: theme.textColorColorfulBackground,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.6,
                                fontSize: 13)),
                      if (subtitle != null) SizedBox(height: 8),
                      Text(title,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: theme.textColorColorfulBackground,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              fontSize: 17)),
                      if (subtitle != null) SizedBox(height: 4),
                    ],
                  ),
                ),
                if (icon != null) icon!
              ]),
              if (extraSpace != null) extraSpace!,
            ],
          )),
    );
  }
}

class FredericAppBarIcon extends StatelessWidget {
  const FredericAppBarIcon(this.icon, {Key? key}) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: theme.textColorColorfulBackground);
  }
}
