import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/goals/frederic_goal.dart';
import 'package:frederic/backend/goals/frederic_goal_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/achievement_screen/confetti_shooter.dart';
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

  static const int animationDelayInMilliseconds = 500;

  static const double startingIconSize = 200.0;
  static const double sizeToMatchIconToScreen = 120;
  static const double iconHeight = 70;

  static double endIconSizeRatio = 0;

  @override
  void initState() {
    endIconSizeRatio = startingIconSize - sizeToMatchIconToScreen;
    _iconController = AnimationController(vsync: this);
    _offsetController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: animationDelayInMilliseconds));

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
        Container(
          padding: const EdgeInsets.only(
              right: 16, left: 16, bottom: 16, top: iconHeight),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.cardBackgroundColor),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: animationDelayInMilliseconds),
            opacity: buttonVisibility ? 1.0 : 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Congratulations!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(text: 'Do you want to save '),
                    TextSpan(
                      text: '"${widget.goal.title}"',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: 'to your achievements?'),
                  ]),
                  textAlign: TextAlign.center,
                ),
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
        buildLottiAssetAnimation(
            'assets/animations/app_icon_animation.json', iconSize),
        buildConfettiShooter(right: 50, alignment: Alignment.bottomRight),
        buildConfettiShooter(left: 50, alignment: Alignment.bottomLeft),
      ],
    );
  }

  Widget buildLottiAssetAnimation(String path, double size) {
    return Positioned.fill(
      top: _offset.value * (-180),
      child: Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          path,
          controller: _iconController,
          onLoaded: (composition) {
            _iconController
              ..duration = composition.duration
              ..forward();
          },
          width: size,
          height: size,
          repeat: false,
        ),
      ),
    );
  }

  Widget buildConfettiShooter({
    Direction direction = Direction.up,
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
    Alignment alignment = Alignment.center,
  }) {
    return Positioned.fill(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Align(
        alignment: alignment,
        child: ConfettiShooter(
          dir: Direction.up,
        ),
      ),
    );
  }

  void handleDelete() {
    FredericBackend.instance.analytics.logAchievementDeleted();
    var goalscount = FredericBackend.instance.userManager.state.goalsCount;
    if (goalscount >= 1)
      FredericBackend.instance.userManager.state.goalsCount -= 1;
    FredericBackend.instance.goalManager
        .add(FredericGoalDeleteEvent(widget.goal));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pop();
    });
  }

  void handleSave() {
    FredericBackend.instance.analytics.logGoalSavedAsAchievement();
    FredericBackend.instance.userManager.state.achievementsCount += 1;
    var goalscount = FredericBackend.instance.userManager.state.goalsCount;
    if (goalscount >= 1)
      FredericBackend.instance.userManager.state.goalsCount -= 1;
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
