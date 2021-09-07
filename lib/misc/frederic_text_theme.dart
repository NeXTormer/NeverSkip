import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericTextTheme {
  static const Color greyTextColor = const Color(0xBF3A3A3A);

  static TextStyle homeScreenAppBarTitle = TextStyle(
      fontFamily: 'Montserrat',
      color: theme.textColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.6,
      fontSize: 13);

  static TextStyle homeScreenAppBarSubTitle = TextStyle(
      fontFamily: 'Montserrat',
      color: theme.textColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontSize: 17);

  static TextStyle cardTitleSmall =
      TextStyle(color: theme.greyColor, fontSize: 10, letterSpacing: 0.3);
}
