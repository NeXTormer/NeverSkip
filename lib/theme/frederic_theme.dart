import 'package:flutter/material.dart';

enum FredericTheme {
  BLUE,
  BLUE_COLORFUL,
  ORANGE,
}

class FredericColorTheme {
  FredericColorTheme.blue(
      {this.mainColor = const Color(0xFF3E4FD8),
      this.mainColorLight = const Color(0x1A3E4FD8),
      this.accentColor = const Color(0xFF4791FF),
      this.accentColorLight = const Color(0xFFF4F7FE),
      this.positiveColor = const Color(0xFF1CBB3F),
      this.positiveColorLight = const Color(0x1A1CBB3F),
      this.negativeColor = Colors.red,
      this.negativeColorLight = const Color(0x1AB71C1C),
      this.dividerColor = const Color(0xFFC9C9C9),
      this.backgroundColor = Colors.white,
      this.backgroundHighlightColor = Colors.white,
      this.cardBackgroundColor = Colors.white,
      this.greyColor = const Color(0xFFC4C4C4),
      this.disabledGreyColor = const Color(0x66A5A5A5),
      this.textColor = const Color(0xFF272727),
      this.textColorBright = Colors.white,
      this.cardBorderColor = const Color(0xFFE2E2E2)});

  FredericColorTheme.blueColorful(
      {this.mainColor = const Color(0xFF3E4FD8),
      this.mainColorLight = const Color(0x1A3E4FD8),
      this.accentColor = const Color(0xFF4791FF),
      this.accentColorLight = const Color(0xFFF4F7FE),
      this.positiveColor = const Color(0xFF1CBB3F),
      this.positiveColorLight = const Color(0x1A1CBB3F),
      this.negativeColor = Colors.red,
      this.negativeColorLight = const Color(0x1AB71C1C),
      this.dividerColor = const Color(0xFFC9C9C9),
      this.backgroundColor = Colors.white,
      this.backgroundHighlightColor = const Color(0xFF3E4FD8),
      this.cardBackgroundColor = Colors.white,
      this.greyColor = const Color(0xFFC4C4C4),
      this.disabledGreyColor = const Color(0x66A5A5A5),
      this.textColor = const Color(0xFF272727),
      this.textColorBright = Colors.white,
      this.cardBorderColor = const Color(0xFFE2E2E2)});

  FredericColorTheme.orange(
      {this.mainColor = const Color(0xFF3E4FD8),
      this.mainColorLight = const Color(0x1A3E4FD8),
      this.accentColor = const Color(0xFF4791FF),
      this.accentColorLight = const Color(0xFFF4F7FE),
      this.positiveColor = const Color(0xFF1CBB3F),
      this.positiveColorLight = const Color(0x1A1CBB3F),
      this.negativeColor = Colors.red,
      this.negativeColorLight = const Color(0x1AB71C1C),
      this.dividerColor = const Color(0xFFC9C9C9),
      this.backgroundColor = Colors.white,
      this.backgroundHighlightColor = Colors.white,
      this.cardBackgroundColor = Colors.white,
      this.greyColor = const Color(0xFFC4C4C4),
      this.disabledGreyColor = const Color(0x66A5A5A5),
      this.textColor = const Color(0xFF272727),
      this.textColorBright = Colors.white,
      this.cardBorderColor = const Color(0xFFE2E2E2)});

  FredericColorTheme.blueDark(
      {this.mainColor = const Color(0xFF3E4FD8),
      this.mainColorLight = const Color(0x1A3E4FD8),
      this.accentColor = const Color(0xFF4791FF),
      this.accentColorLight = const Color(0xFFF4F7FE),
      this.positiveColor = const Color(0xFF1CBB3F),
      this.positiveColorLight = const Color(0x1A1CBB3F),
      this.negativeColor = Colors.red,
      this.negativeColorLight = const Color(0x1AB71C1C),
      this.dividerColor = const Color(0xFFC9C9C9),
      this.backgroundColor = Colors.white,
      this.backgroundHighlightColor = Colors.white,
      this.cardBackgroundColor = Colors.white,
      this.greyColor = const Color(0xFFC4C4C4),
      this.disabledGreyColor = const Color(0x66A5A5A5),
      this.textColor = const Color(0xFF272727),
      this.textColorBright = Colors.white,
      this.cardBorderColor = const Color(0xFFE2E2E2)});

  FredericColorTheme.blueColorfulDark(
      {this.mainColor = const Color(0xFF3E4FD8),
      this.mainColorLight = const Color(0x1A3E4FD8),
      this.accentColor = const Color(0xFF4791FF),
      this.accentColorLight = const Color(0xFFF4F7FE),
      this.positiveColor = const Color(0xFF1CBB3F),
      this.positiveColorLight = const Color(0x1A1CBB3F),
      this.negativeColor = Colors.red,
      this.negativeColorLight = const Color(0x1AB71C1C),
      this.dividerColor = const Color(0xFFC9C9C9),
      this.backgroundColor = Colors.white,
      this.backgroundHighlightColor = Colors.white,
      this.cardBackgroundColor = Colors.white,
      this.greyColor = const Color(0xFFC4C4C4),
      this.disabledGreyColor = const Color(0x66A5A5A5),
      this.textColor = const Color(0xFF272727),
      this.textColorBright = Colors.white,
      this.cardBorderColor = const Color(0xFFE2E2E2)});

  FredericColorTheme.orangeDark(
      {this.mainColor = const Color(0xFF3E4FD8),
      this.mainColorLight = const Color(0x1A3E4FD8),
      this.accentColor = const Color(0xFF4791FF),
      this.accentColorLight = const Color(0xFFF4F7FE),
      this.positiveColor = const Color(0xFF1CBB3F),
      this.positiveColorLight = const Color(0x1A1CBB3F),
      this.negativeColor = Colors.red,
      this.negativeColorLight = const Color(0x1AB71C1C),
      this.dividerColor = const Color(0xFFC9C9C9),
      this.backgroundColor = Colors.white,
      this.backgroundHighlightColor = Colors.white,
      this.cardBackgroundColor = Colors.white,
      this.greyColor = const Color(0xFFC4C4C4),
      this.disabledGreyColor = const Color(0x66A5A5A5),
      this.textColor = const Color(0xFF272727),
      this.textColorBright = Colors.white,
      this.cardBorderColor = const Color(0xFFE2E2E2)});

  Color mainColor;
  Color mainColorLight;
  Color accentColor;
  Color accentColorLight;
  Color positiveColor;
  Color positiveColorLight;
  Color negativeColor;
  Color negativeColorLight;

  Color dividerColor;
  Color backgroundColor;
  Color backgroundHighlightColor;
  Color cardBackgroundColor;
  Color greyColor;
  Color disabledGreyColor;

  Color textColor;
  Color textColorBright;
  Color cardBorderColor;
}
// const Color theme.mainColor = const Color(0xFFD8903E);
// const Color kAccentColor = const Color(0xFFFFEA47);
// const Color theme.mainColorLight = const Color(0x1AD8903E);
// const Color kAccentColorLight = const Color(0xFFFFEA47);
