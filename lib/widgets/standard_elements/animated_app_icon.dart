import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedAppIcon extends StatefulWidget {
  const AnimatedAppIcon(this.callback, {this.size = 60, Key? key})
      : super(key: key);
  final Function callback;
  final double size;

  @override
  _AnimatedAppIconState createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<AnimatedAppIcon>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final AnimationController _offsetController;
  late Animation _topOffset;

  @override
  void initState() {
    _iconController = AnimationController(
      vsync: this,
    );
    _offsetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _topOffset =
        CurvedAnimation(parent: _offsetController, curve: Curves.fastOutSlowIn)
          ..addListener(() {
            setState(() {});
          });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_iconController.isCompleted) _offsetController.forward();
    if (_offsetController.isCompleted) widget.callback();

    return Positioned.fill(
      top: _topOffset.value * (-230),
      child: Align(
        alignment: Alignment.center,
        child: Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_rd5d4ls1.json',
          width: widget.size,
          height: widget.size,
          controller: _iconController,
          frameRate: FrameRate.composition,
          onLoaded: (composition) {
            _iconController
              ..duration = composition.duration
              ..forward();
            Future.delayed(const Duration(milliseconds: 1500), () {
              _offsetController.forward();
            });
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return AnimatedBuilder(
  //       animation: _topOffset,
  //       builder: (context, child) {
  //         return Positioned.fill(
  //           top: _topOffset.value,
  //           child: Align(
  //             alignment: Alignment.center,
  //             child: Lottie.network(
  //               'https://assets9.lottiefiles.com/packages/lf20_rd5d4ls1.json',
  //               width: widget.size,
  //               height: widget.size,
  //               controller: _controller,
  //               frameRate: FrameRate.composition,

  //               onLoaded: (composition) {
  //                 _controller
  //                   ..duration = composition.duration
  //                   ..forward();
  //               },
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  void dispose() {
    _offsetController.dispose();
    _iconController.dispose();
    super.dispose();
  }
}
