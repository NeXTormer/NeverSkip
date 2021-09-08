import 'package:flutter/material.dart';
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
          FredericButton('Dark Blue', onPressed: () {}),
          SizedBox(height: 24),
          FredericButton('Light Blue', onPressed: () {}),
          SizedBox(height: 24),
          FredericButton('Colorful light Blue', onPressed: () {}),
        ],
      ),
    );
  }
}
