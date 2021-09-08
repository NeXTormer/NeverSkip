import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/theme/frederic_theme.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';

class ColorThemeChanger extends StatefulWidget {
  const ColorThemeChanger({Key? key}) : super(key: key);

  @override
  _ColorThemeChangerState createState() => _ColorThemeChangerState();
}

class _ColorThemeChangerState extends State<ColorThemeChanger> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FredericButton('Dark Blue', onPressed: () {
            FredericBase.setColorTheme(context, FredericColorTheme.blueDark());
          }),
          SizedBox(height: 24),
          FredericButton('Light Blue', onPressed: () {
            FredericBase.setColorTheme(context, FredericColorTheme.blue());
          }),
          SizedBox(height: 24),
          FredericButton('Colorful light Blue', onPressed: () {
            FredericBase.setColorTheme(
                context, FredericColorTheme.blueColorful());
          }),
          SizedBox(height: 24),
          FredericButton('Dark Orange', onPressed: () {
            FredericBase.setColorTheme(
                context, FredericColorTheme.blueColorful());
          }),
          SizedBox(height: 24),
          FredericButton('Light Orange', onPressed: () {
            FredericBase.setColorTheme(
                context, FredericColorTheme.blueColorful());
          }),
          FredericButton('Colorful Light Orange', onPressed: () {
            FredericBase.setColorTheme(
                context, FredericColorTheme.blueColorful());
          }),
        ],
      ),
    );
  }
}
