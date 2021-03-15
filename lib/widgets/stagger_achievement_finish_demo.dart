import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/profile_screen/goal/finish_goal_view.dart';
import 'package:frederic/widgets/stagger_achievement_finish_animation.dart';

class StaggerAchievementFinishDemo extends StatefulWidget {
  StaggerAchievementFinishDemo(this.goal);
  final FredericGoal goal;

  @override
  _StaggerAchievementFinishDemoState createState() =>
      _StaggerAchievementFinishDemoState();
}

class _StaggerAchievementFinishDemoState
    extends State<StaggerAchievementFinishDemo> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    _playAnimation();
    return Container(
      child: Center(
        child: Container(
          child: _controller.isCompleted
              ? FinishGoalView(widget.goal, Mode.GOAL)
              : StaggerAchievementFinishAnimation(
                  controller: _controller.view,
                ),
        ),
      ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      setState(() {});

      //await _controller.reverse().orCancel;

    } on TickerCanceled {}
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }
}
