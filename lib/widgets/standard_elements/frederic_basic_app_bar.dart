import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericBasicAppBar extends StatelessWidget {
  FredericBasicAppBar(
      {required this.title, this.subtitle, this.icon, bool? rounded, Key? key})
      : super(key: key) {
    this.rounded = rounded ?? theme.isColorful;
  }

  final String title;
  final String? subtitle;
  final Widget? icon;
  late final bool rounded;

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
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle ?? '',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: theme.textColorColorfulBackground,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                        fontSize: 13)),
                SizedBox(height: 8),
                Text(title,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: theme.textColorColorfulBackground,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        fontSize: 17)),
                SizedBox(height: 4),
              ],
            ),
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
