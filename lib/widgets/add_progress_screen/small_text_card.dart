import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class SmallTextCard extends StatelessWidget {
  const SmallTextCard(this.text,
      {this.height = 42,
      this.onTap,
      this.onLongPress,
      this.width,
      this.textSize = 18,
      this.selected = false,
      Key? key})
      : super(key: key);

  final bool selected;
  final double? height;
  final double? width;
  final double textSize;
  final String text;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      height: height,
      onTap: onTap,
      onLongPress: onLongPress,
      width: width,
      color: selected
          ? theme.mainColor.withOpacity(0.1)
          : theme.cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(text,
              style: TextStyle(
                color: selected ? theme.mainColorInText : theme.textColor,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                letterSpacing: 0.1,
                fontSize: textSize,
              )),
        ),
      ),
    );
  }
}
