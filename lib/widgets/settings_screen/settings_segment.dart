import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/settings_screen/settings_element.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class SettingsSegment extends StatelessWidget {
  const SettingsSegment({required this.title, required this.elements, Key? key})
      : super(key: key);

  final String title;
  final List<SettingsElement> elements;

  @override
  Widget build(BuildContext context) {
    elements[0].isFirstItem = true;
    elements[elements.length - 1].isLastItem = true;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: FredericHeading(title),
            ),
            SizedBox(height: 8),
            FredericCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    elements.length + (elements.length - 1),
                    (index) => index % 2 == 1
                        ? Container(
                            height: 1,
                            color:
                                theme.isDark ? Colors.white12 : Colors.black12,
                          )
                        : elements[index ~/ 2]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
