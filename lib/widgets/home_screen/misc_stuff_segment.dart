import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/screens/history_screen.dart';
import 'package:frederic/widgets/home_screen/misc_list_item.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class MiscStuffSegment extends StatelessWidget {
  const MiscStuffSegment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            FredericHeading.translate('home.other'),
            SizedBox(height: 12),
            MiscListItem(
              text: tr('home.history_button'),
              icon: Icons.history,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => HistoryScreen())),
            )
          ],
        ),
      ),
    );
  }
}
