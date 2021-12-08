import 'package:flutter/material.dart';

import '../../../main.dart';
import '../frederic_card.dart';
import '../picture_icon.dart';

class DummyActivityCard extends StatelessWidget {
  const DummyActivityCard(
      {this.icon, required this.name, required this.description, Key? key})
      : super(key: key);

  final String? icon;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      height: 60,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
              width: 40,
              height: 40,
              child: AspectRatio(
                  aspectRatio: 1,
                  child: PictureIcon(
                    icon,
                    mainColor: theme.mainColorInText,
                  ))),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: theme.textColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(
                          color: theme.greyTextColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                          fontSize: 12),
                      text: description),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
