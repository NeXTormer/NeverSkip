import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_user_builder.dart';
import 'package:frederic/widgets/home_screen/goal_segment.dart';
import 'package:frederic/widgets/home_screen/home_screen_appbar.dart';
import 'package:frederic/widgets/home_screen/progress_indicator_segment.dart';

class HomeScreen extends StatelessWidget {
  static const double SIDE_PADDING = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FredericUserBuilder(builder: (context, user) {
            return CustomScrollView(
              slivers: [
                HomeScreenAppbar(),
                SliverToBoxAdapter(
                    child: Divider(color: const Color(0xFFC9C9C9))),
                ProgressIndicatorSegment(),
                GoalSegment(),
                SliverToBoxAdapter(
                  child: Container(height: 2000, color: Colors.white),
                ),
              ],
            );
          }),
        ));
  }
}
