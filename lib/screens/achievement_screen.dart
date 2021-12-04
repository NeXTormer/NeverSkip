import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/achievement_screen/achievement_progress_bar.dart';
import 'package:frederic/widgets/achievement_screen/achievement_timeline.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/goal_cards/goal_card_medaille_indicator.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

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
              buildTimelineSegment(),
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Text(goal.title),
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
                  AchievementProgressBar(goal, goal.startState.toDouble()),
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
                  AchievementProgressBar(
                    goal,
                    goal.endState.toDouble(),
                    progressRatio: 0.96,
                    delayInMillisecond: 200,
                  ),
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
    Widget _buildCircleWithTitleAndText(String title, String text) {
      return Column(
        children: [
          Text(title),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.mainColor,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: theme.backgroundColor,
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.textColor),
                ),
              ),
            ),
          )
        ],
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardBackgroundColor,
          border: Border.all(color: theme.cardBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleWithTitleAndText('Avr. Workout Time', '30\nmin'),
            _buildCircleWithTitleAndText('Avr. Workout Time', '30\nmin')
          ],
        ),
      ),
    );
  }

  Widget buildTimelineSegment() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
            child: AchievementTimeline(
              goal,
              width: 330,
              height: 5,
              delayInMillisecond: 1000,
            ),
          ),
        ],
      ),
    );
  }
}
