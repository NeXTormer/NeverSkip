import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericBasicAppBar extends StatelessWidget {
  FredericBasicAppBar(
      {required this.title,
      this.subtitle,
      this.leadingIcon,
      this.backButton = false,
      this.bottomPadding = 16,
      this.icon,
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
  late final bool rounded;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
          borderRadius: rounded
              ? BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))
              : null),
      child: Padding(
          padding: EdgeInsets.only(
              left: 16, right: 16, top: 20, bottom: bottomPadding),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            Column(
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
            Expanded(child: Container()),
            if (icon != null) icon!
          ])),
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
