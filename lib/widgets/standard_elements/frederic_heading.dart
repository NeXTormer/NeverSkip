import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';

class FredericHeading extends StatelessWidget {
  const FredericHeading(this.heading,
      {this.onPressed,
      this.subHeading,
      this.iconWidget,
      this.icon = ExtraIcons.dots,
      this.fontSize = 15});

  FredericHeading.translate(String key,
      {this.onPressed,
      this.subHeading,
      this.iconWidget,
      this.icon = ExtraIcons.dots,
      this.fontSize = 15})
      : heading = tr(key);

  final Function? onPressed;
  final String heading;
  final String? subHeading;
  final IconData? icon;
  final double fontSize;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    bool showSubHeading = subHeading != null;
    return Row(
      mainAxisAlignment: iconWidget != null && subHeading == null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        Flexible(
          //fit: FlexFit.tight,
          flex: subHeading == null && onPressed == null ? 1 : 0,
          child: Text(heading,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                  color: theme.textColor,
                  letterSpacing: 0.6)),
        ),
        if (showSubHeading) SizedBox(width: 8),
        if (showSubHeading)
          Container(
            width: 1,
            height: 18,
            decoration: BoxDecoration(
                color: const Color(0xFFCDCDCD),
                borderRadius: BorderRadius.all(Radius.circular(100))),
          ),
        if (showSubHeading) SizedBox(width: 8),
        if (showSubHeading)
          Expanded(
            child: Text(subHeading!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: const Color(0xF2A5A5A5),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.6)),
          ),
        if (subHeading == null && onPressed != null)
          Flexible(
              child: Container(
            height: 20,
          )),
        if (iconWidget != null) iconWidget!,
        if (onPressed != null && icon != null)
          InkWell(
            onTap: onPressed as void Function()?,
            child: Icon(
              icon,
              color: const Color(0xFFC4C4C4),
            ),
          )
      ],
    );
  }
}
