import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class ShadowCustomScrollView extends StatefulWidget {
  const ShadowCustomScrollView(
      {this.slivers = const <Widget>[],
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.shadowWidth = 14,
      this.blurPadding = const EdgeInsets.all(0),
      Key? key})
      : super(key: key);

  final Axis scrollDirection;
  final bool reverse;
  final List<Widget> slivers;
  final EdgeInsets blurPadding;
  final double shadowWidth;

  @override
  _ShadowCustomScrollViewState createState() => _ShadowCustomScrollViewState();
}

class _ShadowCustomScrollViewState extends State<ShadowCustomScrollView> {
  bool showShadow = true;

  @override
  Widget build(BuildContext context) {
    var color1 =
        theme.isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(50);
    var color2 =
        theme.isDark ? Colors.black.withAlpha(50) : Colors.white.withAlpha(30);
    if (!showShadow) {
      color1 = Colors.transparent;
      color2 = Colors.transparent;
    }

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels <
                notification.metrics.maxScrollExtent) {
              setState(() {
                showShadow = true;
              });
            } else {
              setState(() {
                showShadow = false;
              });
            }
            return true;
          },
          child: CustomScrollView(
            scrollDirection: widget.scrollDirection,
            physics: BouncingScrollPhysics(),
            reverse: widget.reverse,
            slivers: widget.slivers,
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: widget.blurPadding,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: widget.shadowWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color1, color2]),
                  )),
            )),
      ],
    );
  }
}
