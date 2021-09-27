import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericContainerTransition extends StatelessWidget {
  const FredericContainerTransition({
    required this.childBuilder,
    required this.expandedChild,
    this.dragThreshold = 3,
    this.closedBorderRadius = 8,
    this.customBorder,
    this.tappable = false,
    this.transitionType = ContainerTransitionType.fadeThrough,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext, VoidCallback) childBuilder;
  final Widget expandedChild;
  final double dragThreshold;
  final double closedBorderRadius;
  final bool tappable;
  final ShapeBorder? customBorder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: tappable,
      closedBuilder: childBuilder,
      openBuilder: (context, closeContainer) => GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx >= dragThreshold) {
              closeContainer();
            }
          },
          child: expandedChild),
      openElevation: 0,
      closedElevation: 0,
      transitionType: transitionType,
      openColor: theme.backgroundColor,
      closedColor: theme.backgroundColor,
      closedShape: customBorder != null
          ? customBorder!
          : RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(closedBorderRadius))),
    );
  }
}
