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
    this.containerKey,
    this.onClose,
    this.closedColor,
    this.tappable = false,
    this.transitionType = ContainerTransitionType.fadeThrough,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext, VoidCallback) childBuilder;
  final Widget expandedChild;
  final GlobalKey? containerKey;
  final double dragThreshold;
  final double closedBorderRadius;
  final bool tappable;
  final ShapeBorder? customBorder;
  final ContainerTransitionType transitionType;
  final void Function()? onClose;
  final Color? closedColor;


  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      key: containerKey,
      tappable: tappable,
      closedBuilder: childBuilder,
      openBuilder: (context, closeContainer) =>
          GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx >= dragThreshold) {
                  onClose?.call();
                  closeContainer();
                }
              },
              child: SafeArea(bottom: false, child: expandedChild)),
      openElevation: 0,
      closedElevation: 0,
      transitionType: transitionType,
      openColor: theme.backgroundColor,
      closedColor: closedColor ?? theme.backgroundColor,
      closedShape: customBorder != null
          ? customBorder!
          : RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(closedBorderRadius))),
    );
  }
}
