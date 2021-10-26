import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/theme/frederic_theme.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';

class ColorThemeCard extends StatelessWidget {
  const ColorThemeCard(this.localTheme, {Key? key, this.selected = false})
      : super(key: key);

  final FredericColorTheme localTheme;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 120,
      decoration: BoxDecoration(
          color: localTheme.cardBackgroundColor,
          border:
              theme.isDark ? null : Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Container(
            height: 35,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
                color: localTheme.isColorful
                    ? localTheme.mainColor
                    : localTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(7),
                    bottomLeft: Radius.circular(7))),
            child: Text(
              'SilverFit',
              style: TextStyle(
                  color: localTheme.textColorColorfulBackground,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
          if (!localTheme.isColorful) FredericDivider(),
          Expanded(
              child: Container(
            color: localTheme.cardBackgroundColor,
            child: Column(
              children: [
                SizedBox(height: 6),
                buildElement(false),
                buildElement(false),
                buildElement(false),
                buildElement(true),
              ],
            ),
          )),
          Container(
            height: 25,
            decoration: BoxDecoration(
                color: localTheme.isColorful
                    ? localTheme.mainColor
                    : localTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6))),
          ),
        ],
      ),
    );
  }

  Widget buildElement(bool short) {
    return Container(
      height: 12,
      margin: short
          ? const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 60)
          : const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
      decoration: BoxDecoration(
          color: localTheme.mainColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }
}
