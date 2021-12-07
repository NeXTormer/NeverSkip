import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:lottie/lottie.dart';

class GoalFinishActionDialog extends StatefulWidget {
  const GoalFinishActionDialog(this.goal, {Key? key}) : super(key: key);
  final FredericGoal goal;

  @override
  State<GoalFinishActionDialog> createState() => _GoalFinishActionDialogState();
}

class _GoalFinishActionDialogState extends State<GoalFinishActionDialog>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final AnimationController _offsetController;
  late Animation _offset;
  late Animation _size;
  bool buttonVisibility = false;

  double startingIconSize = 200.0;
  double endIconSizeRatio = 0;

  @override
  void initState() {
    endIconSizeRatio = startingIconSize - 120;
    _iconController = AnimationController(vsync: this);
    _offsetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _offset =
        CurvedAnimation(parent: _offsetController, curve: Curves.decelerate)
          ..addListener(() {
            setState(() {
              if (_offsetController.isCompleted) buttonVisibility = true;
            });
          });
    _size =
        CurvedAnimation(parent: _offsetController, curve: Curves.decelerate);

    _iconController
      ..addListener(() {
        if (_iconController.isCompleted) {
          _offsetController.forward();
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = startingIconSize - _size.value * endIconSizeRatio;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.cardBackgroundColor),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: buttonVisibility ? 1.0 : 0.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Congratulations!',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                      'Do you want to save "${widget.goal.title}" to your achievements?',
                      textAlign: TextAlign.center),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: FredericButton('Delete', inverted: true,
                              onPressed: () {
                            handleDelete();
                          }, mainColor: Colors.red),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: FredericButton('Save', onPressed: () {
                          handleSave();
                        }, inverted: false)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: _offset.value * (-180),
          child: Align(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/animations/app_icon_animation.json',
              controller: _iconController,
              onLoaded: (composition) {
                _iconController
                  ..duration = composition.duration
                  ..forward();
              },
              width: iconSize,
              height: iconSize,
              repeat: false,
            ),
          ),
        ),
      ],
    );
  }

  void handleDelete() {
    FredericBackend.instance.analytics.logAchievementDeleted();
    FredericBackend.instance.goalManager
        .add(FredericGoalDeleteEvent(widget.goal));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pop();
    });
  }

  void handleSave() {
    FredericBackend.instance.analytics.logGoalSavedAsAchievement();
    widget.goal.isCompleted = true;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _offsetController.dispose();
    super.dispose();
  }
}
