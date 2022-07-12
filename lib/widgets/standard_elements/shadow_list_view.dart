import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class ShadowListView extends StatefulWidget {
  const ShadowListView(
      {required this.itemBuilder,
      this.scrollDirection = Axis.horizontal,
      this.reverse = false,
      this.physics = const BouncingScrollPhysics(),
      this.shadowWidth = 14,
      this.blurPadding = const EdgeInsets.all(0),
      this.controller,
      this.itemCount,
      this.prototypeItem,
      Key? key})
      : super(key: key);

  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollPhysics physics;
  final Axis scrollDirection;
  final bool reverse;
  final EdgeInsets blurPadding;
  final double shadowWidth;
  final ScrollController? controller;
  final int? itemCount;
  final Widget? prototypeItem;

  @override
  _ShadowListViewState createState() => _ShadowListViewState();
}

class _ShadowListViewState extends State<ShadowListView> {
  bool shadowLeft = true;
  bool shadowRight = false;

  @override
  Widget build(BuildContext context) {
    var color1 =
        theme.isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(50);
    var color2 =
        theme.isDark ? Colors.black.withAlpha(50) : Colors.white.withAlpha(30);

    var colora =
        theme.isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(50);
    var colorb =
        theme.isDark ? Colors.black.withAlpha(50) : Colors.white.withAlpha(30);

    if (!shadowLeft) {
      color1 = Colors.transparent;
      color2 = Colors.transparent;
    }
    if (!shadowRight) {
      colora = Colors.transparent;
      colorb = Colors.transparent;
    }

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels <
                notification.metrics.maxScrollExtent) {
              setState(() {
                shadowLeft = true;
              });
            } else {
              setState(() {
                shadowLeft = false;
              });
            }
            if (notification.metrics.pixels >
                notification.metrics.minScrollExtent) {
              setState(() {
                shadowRight = true;
              });
            } else {
              setState(() {
                shadowRight = false;
              });
            }
            return true;
          },
          child: ListView.builder(
              controller: widget.controller,
              prototypeItem: widget.prototypeItem,
              itemCount: widget.itemCount,
              scrollDirection: widget.scrollDirection,
              physics: widget.physics,
              reverse: widget.reverse,
              itemBuilder: widget.itemBuilder),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: widget.blurPadding,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: widget.shadowWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [color1, color2],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter),
                  )),
            )),
        Positioned(
            right: 0,
            top: 0,
            left: 0,
            child: Padding(
              padding: widget.blurPadding,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: widget.shadowWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [colorb, colora],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter),
                  )),
            )),
      ],
    );
  }
}
