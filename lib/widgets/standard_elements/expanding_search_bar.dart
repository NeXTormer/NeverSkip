import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

import 'frederic_text_field.dart';

class ExpandingSearchBar extends StatelessWidget {
  const ExpandingSearchBar({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FredericContainerTransition(
        childBuilder: (context, openContainer) {
          return FredericCard(
            onTap: openContainer,
            height: 42,
            borderWidth: 0.7,
            color: theme.cardBackgroundColor,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.search,
                  color: theme.mainColorInText,
                ),
                const SizedBox(width: 10),
                Text(
                  'Search...',
                  style: TextStyle(
                      color: theme.textColor, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 12),
              ],
            ),
          );
          return FredericTextField(
            'Search...',
            onColorfulBackground: theme.isColorful,
            brightContents: theme.isColorful,
            icon: Icons.search,
            size: 20,
            suffixIcon: Icons.highlight_remove_outlined,
          );
        },
        expandedChild: child);
  }
}
