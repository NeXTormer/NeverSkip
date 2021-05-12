import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericTextTheme {
  static const Color greyTextColor = const Color(0x7A3A3A3A);

  static const TextStyle homeScreenAppBarTitle = const TextStyle(
      fontFamily: 'Montserrat',
      color: kTextColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.6,
      fontSize: 13);

  static const TextStyle homeScreenAppBarSubTitle = const TextStyle(
      fontFamily: 'Montserrat',
      color: kTextColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontSize: 17);

  static const TextStyle cardTitleSmall =
      const TextStyle(color: greyTextColor, fontSize: 10, letterSpacing: 0.3);
}
