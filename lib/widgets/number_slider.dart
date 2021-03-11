import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberSlider extends StatefulWidget {
  NumberSlider({this.controller, this.width = 220, this.startingIndex = 10});
  final int startingIndex;
  final double width;
  final NumberSliderController controller;

  @override
  _NumberSliderState createState() => _NumberSliderState();
}

class _NumberSliderState extends State<NumberSlider> {
  PageController controller;

  @override
  void initState() {
    controller = PageController(
        viewportFraction: 0.2,
        initialPage: widget.startingIndex,
        keepPage: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int start = widget.startingIndex - 2;
    if (start < 0) start = 0;
    Future.delayed(Duration.zero).then((value) => controller.jumpToPage(start));
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        height: 50,
        width: widget.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -6,
              child: Container(
                width: 50,
                //height: double.infinity,
                child: Container(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PageView.builder(
              itemBuilder: (context, index) => _NumberSliderElement(index + 1),
              itemCount: 400,
              physics: BouncingScrollPhysics(),
              pageSnapping: false,
              onPageChanged: (index) {
                widget.controller.value = index + 1;
                HapticFeedback.selectionClick();
              },
              controller: controller,
            ),
          ],
        ));
  }
}

class _NumberSliderElement extends StatelessWidget {
  _NumberSliderElement(this.number);

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class NumberSliderController {
  num value;
}

class XSnappingPageScroll extends StatefulWidget {
  const XSnappingPageScroll({
    Key key,
    @required this.children,
    this.onPageChanged,
    this.initialPage,
    this.scrollDirection,
    this.showPageIndicator,
    this.currentPageIndicator,
    this.otherPageIndicator,
    this.viewportFraction,
  }) : super(key: key);

  ///The pages that the widget will scroll between and snap to.
  final List<Widget> children;

  ///Called when the page changes.
  final ValueChanged<int> onPageChanged;

  ///Index of the page that is shown initially.
  final int initialPage;

  ///The axis on which the pages is scrolled along.
  final Axis scrollDirection;

  ///Option to enable / disable page indicators.
  final bool showPageIndicator;

  ///Widget to use as indicator for the page currently on screen.
  final Widget currentPageIndicator;

  ///Widget to use as indicator for the pages that not on screen.
  final Widget otherPageIndicator;

  ///With of page, where 1 is 100% of the screen.
  final double viewportFraction;

  @override
  _XSnappingPageScrollState createState() => _XSnappingPageScrollState();
}

class _XSnappingPageScrollState extends State<XSnappingPageScroll> {
  PageController _pageController;
  int time;
  double position;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: widget.viewportFraction ?? 1,
      initialPage: widget.initialPage ?? 0,
    );
    super.initState();
  }

  Widget defaultIndicator(Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      ///Get pointer (finger) position.
      onPointerMove: (PointerMoveEvent pos) {
        ///Runs if the time since the last scroll is undefined or over 100 milliseconds.
        if (time == null ||
            DateTime.now().millisecondsSinceEpoch - time > 100) {
          time = DateTime.now().millisecondsSinceEpoch;
          position = pos.position.dx;

          ///The fingers x-coordinate.
        } else {
          ///Calculates scroll velocity.
          final double v = (position - pos.position.dx) /
              (DateTime.now().millisecondsSinceEpoch - time);

          ///If the scroll velocity is to low, the widget will scroll as a PageView widget with
          ///pageSnapping turned on.
          if ((v < -1 || v > 1) &&
              !(v == double.nan ||
                  v == double.infinity ||
                  v == double.negativeInfinity)) {
            ///Scrolls to a certain page based on the scroll velocity
            //The velocity coefficient (v * velocity coefficient) can be increased to scroll faster,
            //and thus further before snapping.
            _pageController.animateToPage(_currentPage + (v * 1.2).round(),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic);
          }
        }
      },
      child: ScrollConfiguration(
        behavior: CustomScroll(),
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });

                ///onPageChanged will pass the current page to the widget if that parameter is used
                if (widget.onPageChanged != null) {
                  widget.onPageChanged(page);
                }
              },
              //BouncingScrollPhysics can't be used since that will scroll to far because of the animation
              physics: const ClampingScrollPhysics(),

              ///Scroll direction will default to horizontal unless otherwise is specified
              scrollDirection: widget.scrollDirection ?? Axis.horizontal,
              children: widget.children,
            ),
            Visibility(
              visible: widget.showPageIndicator ?? false,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ///Builds one indicator for every page
                  for (int i = 0; i < widget.children.length; i++)
                    i == _currentPage
                        ? (widget.currentPageIndicator ??
                            defaultIndicator(Colors.white))
                        : (widget.otherPageIndicator ??
                            defaultIndicator(Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Used to remove scroll glow
class CustomScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
