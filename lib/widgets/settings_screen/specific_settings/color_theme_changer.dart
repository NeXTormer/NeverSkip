import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/theme/frederic_theme.dart';
import 'package:frederic/widgets/settings_screen/color_theme_card.dart';

class ColorThemeChanger extends StatefulWidget {
  const ColorThemeChanger({Key? key}) : super(key: key);

  @override
  _ColorThemeChangerState createState() => _ColorThemeChangerState();
}

class _ColorThemeChangerState extends State<ColorThemeChanger> {
  List<FredericColorTheme> themes = FredericColorTheme.allThemes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            return GestureDetector(
                onTap: () {
                  FredericBase.setColorTheme(context, themes[index]);
                },
                child: ColorThemeCard(
                  themes[index],
                  selected: theme.uid == themes[index].uid,
                ));
          }, childCount: themes.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          )),
    );
  }
}
