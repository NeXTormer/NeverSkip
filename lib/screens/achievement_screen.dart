import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/achievement_screen/achievement_progress_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card_medaille_indicator.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: ModalScrollController.of(context),
            slivers: [
              SliverPadding(padding: const EdgeInsets.only(bottom: 12)),
              buildHeaderSegment(),
              SliverDivider(),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: FredericHeading('Title'),
                ),
              ),
              buildTitleSegment(),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: FredericHeading('Your Progress'),
                ),
              ),
              buildProgressSegment(),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: FredericHeading('Stats'),
                ),
              ),
              buildStatsSegment(),
            ],
          ),
          Positioned(
            right: 30,
            top: -8,
            child: GoalCardMedailleIndicator(
              size: 90,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderSegment() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(
              ExtraIcons.dumbbell,
              color: theme.mainColor,
            ),
            SizedBox(width: 32),
            Text(
              'Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitleSegment() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FredericTextField(
          'widget.goal.title',
          maxLength: 30,
          text: 'widget.goal.title',
          icon: null,
        ),
      ),
    );
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: theme.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildProgressSegment() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Column(
          children: [
            buildSubHeading('Starting Level', Icons.alarm),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AchievementProgressBar(0.5),
                ],
              ),
            ),
            SizedBox(height: 30),
            buildSubHeading('Finish Level', Icons.ac_unit),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AchievementProgressBar(0.95),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildStatsSegment() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Column(
          children: [
            Text('Hello'),
          ],
        ),
      ),
    );
  }
}
